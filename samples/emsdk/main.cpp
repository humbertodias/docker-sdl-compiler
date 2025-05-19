#include <SDL.h>
#include <stdio.h>
#include <emscripten.h>

SDL_Window* window;
SDL_Renderer* renderer;

void main_loop(void) {
    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
}

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }

    window = SDL_CreateWindow("Hello SDL2 + Emscripten",
                          SDL_WINDOWPOS_CENTERED,
                          SDL_WINDOWPOS_CENTERED,
                          640, 480,
                          SDL_WINDOW_SHOWN);
    renderer = SDL_CreateRenderer(window, -1, 0);

    emscripten_set_main_loop(main_loop, 0, 1);

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
