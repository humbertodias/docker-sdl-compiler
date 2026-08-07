#include <SDL.h>
#include <stdio.h>
#include <emscripten.h>

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;

void main_loop(void) {
    if (!renderer) {
        return;
    }

    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
}

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }

    // Register the loop before CreateRenderer so eglSwapInterval can set
    // timing (emscripten #7100). Use simulateInfiniteLoop=0 so main can
    // continue and create the window/renderer afterward.
    emscripten_set_main_loop(main_loop, 0, 0);

    window = SDL_CreateWindow(
        "Hello SDL2 + Emscripten",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        640, 480,
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

    emscripten_set_main_loop_timing(EM_TIMING_RAF, 0);
    return 0;
}
