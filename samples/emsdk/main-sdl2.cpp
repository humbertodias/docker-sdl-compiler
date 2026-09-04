#include <SDL2/SDL.h>
#include <stdio.h>
#include <emscripten.h>
#include "hello_common.h"

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;
SDL_Texture* card = NULL;
int card_w = HELLO_CARD_W;
int card_h = HELLO_CARD_H;

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

void main_loop(void) {
    if (!renderer || !card) {
        return;
    }

    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);

    SDL_Rect dst = {
        (HELLO_SCREEN_W - card_w) / 2,
        (HELLO_SCREEN_H - card_h) / 2,
        card_w,
        card_h
    };
    SDL_RenderCopy(renderer, card, NULL, &dst);
    SDL_RenderPresent(renderer);
}

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }

    emscripten_set_main_loop(main_loop, 0, 0);

    window = SDL_CreateWindow(
        "Hello SDL2 + Emscripten",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        HELLO_SCREEN_W, HELLO_SCREEN_H,
        SDL_WINDOW_SHOWN
    );
    if (!window) {
        printf("SDL_CreateWindow failed: %s\n", SDL_GetError());
        return 1;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        printf("SDL_CreateRenderer failed: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        return 1;
    }

    card = create_hello_card(renderer);
    if (!card) {
        printf("Failed to create hello card\n");
        return 1;
    }

    emscripten_set_main_loop_timing(EM_TIMING_RAF, 0);
    return 0;
}
