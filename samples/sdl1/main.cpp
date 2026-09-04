#include <SDL/SDL.h>
#include <stdio.h>
#include "hello_common.h"

static void fill_surface(void* ctx, int x, int y, int w, int h, unsigned color) {
    SDL_Surface* s = (SDL_Surface*)ctx;
    SDL_Rect r;
    r.x = (Sint16)x;
    r.y = (Sint16)y;
    r.w = (Uint16)w;
    r.h = (Uint16)h;
    SDL_FillRect(s, &r, color);
}

static SDL_Surface* create_hello_card(SDL_Surface* screen_fmt) {
    SDL_Surface* surface = SDL_CreateRGBSurface(
        SDL_SWSURFACE, HELLO_CARD_W, HELLO_CARD_H,
        screen_fmt->format->BitsPerPixel,
        screen_fmt->format->Rmask,
        screen_fmt->format->Gmask,
        screen_fmt->format->Bmask,
        screen_fmt->format->Amask
    );
    if (!surface) {
        return NULL;
    }

    unsigned bg = SDL_MapRGB(surface->format, 255, 255, 255);
    unsigned border = SDL_MapRGB(surface->format, 30, 30, 30);
    unsigned text = SDL_MapRGB(surface->format, 20, 20, 20);
    const SDL_version* ver = SDL_Linked_Version();
    hello_paint_card(fill_surface, surface, bg, border, text, ver->major, ver->minor, ver->patch);
    return surface;
}

static void present(SDL_Surface* screen, SDL_Surface* card) {
    Uint32 bg = SDL_MapRGB(screen->format, 0, 128, 255);
    SDL_FillRect(screen, NULL, bg);

    if (card) {
        SDL_Rect dst;
        dst.x = (Sint16)((HELLO_SCREEN_W - card->w) / 2);
        dst.y = (Sint16)((HELLO_SCREEN_H - card->h) / 2);
        dst.w = (Uint16)card->w;
        dst.h = (Uint16)card->h;
        SDL_BlitSurface(card, NULL, screen, &dst);
    }

    SDL_Flip(screen);
}

int main(int argc, char* argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }
    atexit(SDL_Quit);

    SDL_Surface* screen = SDL_SetVideoMode(HELLO_SCREEN_W, HELLO_SCREEN_H, 32, SDL_SWSURFACE);
    if (!screen) {
        printf("SDL_SetVideoMode failed: %s\n", SDL_GetError());
        return 1;
    }

    SDL_WM_SetCaption("Hello SDL1", NULL);
    SDL_Surface* card = create_hello_card(screen);
    if (!card) {
        printf("Failed to create hello card\n");
        return 1;
    }

    present(screen, card);

    int running = 1;
    SDL_Event event;
    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                running = 0;
            }
        }
        present(screen, card);
        SDL_Delay(10);
    }

    SDL_FreeSurface(card);
    return 0;
}
