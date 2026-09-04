#include "sdl.h"
#include <stdio.h>
#include <emscripten.h>
#include "hello_common.h"

SDL_Surface* screen = NULL;
SDL_Surface* card = NULL;

static void fill_surface(void* ctx, int x, int y, int w, int h, unsigned color) {
    SDL_Surface* s = (SDL_Surface*)ctx;
    SDL_Rect r = {x, y, w, h};
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

void main_loop(void) {
    Uint32 bg = SDL_MapRGB(screen->format, 0, 128, 255);
    SDL_FillRect(screen, NULL, bg);

    if (card) {
        SDL_Rect dst = {
            (HELLO_SCREEN_W - card->w) / 2,
            (HELLO_SCREEN_H - card->h) / 2,
            card->w,
            card->h
        };
        SDL_BlitSurface(card, NULL, screen, &dst);
    }

    SDL_Flip(screen);
}

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }

    screen = SDL_SetVideoMode(HELLO_SCREEN_W, HELLO_SCREEN_H, 32, SDL_SWSURFACE);
    if (!screen) {
        printf("SDL_SetVideoMode failed: %s\n", SDL_GetError());
        return 1;
    }

    SDL_WM_SetCaption("Hello SDL1 + Emscripten", NULL);
    card = create_hello_card(screen);
    if (!card) {
        printf("Failed to create hello card\n");
        return 1;
    }

    emscripten_set_main_loop(main_loop, 0, 1);
    return 0;
}
