#include "sdl.h"
#include <stdio.h>
#include "hello_common.h"

static void fill_surface(void* ctx, int x, int y, int w, int h, unsigned color) {
    SDL_Surface* s = (SDL_Surface*)ctx;
    SDL_Rect r = {x, y, w, h};
    SDL_FillRect(s, &r, color);
}

static SDL_Texture* create_hello_card(SDL_Renderer* r) {
    SDL_Surface* surface = SDL_CreateRGBSurfaceWithFormat(0, HELLO_CARD_W, HELLO_CARD_H, 32, SDL_PIXELFORMAT_RGBA32);
    if (!surface) {
        return NULL;
    }

    unsigned bg = SDL_MapRGBA(surface->format, 255, 255, 255, 255);
    unsigned border = SDL_MapRGBA(surface->format, 30, 30, 30, 255);
    unsigned text = SDL_MapRGBA(surface->format, 20, 20, 20, 255);
    SDL_version ver;
    SDL_GetVersion(&ver);
    hello_paint_card(fill_surface, surface, bg, border, text, ver.major, ver.minor, ver.patch);

    SDL_Texture* texture = SDL_CreateTextureFromSurface(r, surface);
    SDL_FreeSurface(surface);
    return texture;
}

static void present(SDL_Renderer* renderer, SDL_Texture* card) {
    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);

    SDL_Rect dst = {
        (HELLO_SCREEN_W - HELLO_CARD_W) / 2,
        (HELLO_SCREEN_H - HELLO_CARD_H) / 2,
        HELLO_CARD_W,
        HELLO_CARD_H
    };
    SDL_RenderCopy(renderer, card, NULL, &dst);
    SDL_RenderPresent(renderer);
}

int main(int argc, char* argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        return 1;
    }

    SDL_Window* window = SDL_CreateWindow(
        "Hello SDL2",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        HELLO_SCREEN_W, HELLO_SCREEN_H,
        SDL_WINDOW_SHOWN
    );
    if (!window) {
        SDL_Log("SDL_CreateWindow failed: %s", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        SDL_Log("SDL_CreateRenderer failed: %s", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    SDL_Texture* card = create_hello_card(renderer);
    if (!card) {
        SDL_Log("Failed to create hello card");
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    int quit = 0;
    SDL_Event e;
    while (!quit) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                quit = 1;
            }
        }
        present(renderer, card);
        SDL_Delay(10);
    }

    SDL_DestroyTexture(card);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
