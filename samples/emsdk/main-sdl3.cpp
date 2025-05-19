#include <SDL3/SDL.h>
#include <emscripten.h>
#include <stdio.h>

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;
int quit = 0;

// This function is called repeatedly by emscripten's main loop
void main_loop(void) {
    SDL_Event event;

    // Process all pending events
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_EVENT_QUIT) {
            quit = 1;
        }
    }

    if (quit) {
        // Stop the emscripten main loop and clean up resources
        emscripten_cancel_main_loop();

        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return;
    }

    // Set the draw color to black and clear the screen
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    // Present the backbuffer to the screen
    SDL_RenderPresent(renderer);
}

int main(int argc, char* argv[]) {
    if (SDL_Init(0) != 0) {
        printf("SDL_Init(0) Error: %s\n", SDL_GetError());
        return 1;
    }

    if (SDL_InitSubSystem(SDL_INIT_VIDEO) != 0) {
        printf("SDL_InitSubSystem Error: %s\n", SDL_GetError());
        return 1;
    }

    // Create a window
    window = SDL_CreateWindow("Hello SDL3", 640, 480, 0);
    if (!window) {
        printf("SDL_CreateWindow Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    // Create a renderer for the window
    renderer = SDL_CreateRenderer(window, NULL);
    if (!renderer) {
        printf("SDL_CreateRenderer Error: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    // Register the main loop function with emscripten
    emscripten_set_main_loop(main_loop, 0, 1);

    // This point is never reached because emscripten_set_main_loop doesn't return
    return 0;
}
