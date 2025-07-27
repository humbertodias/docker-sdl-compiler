#include <SDL3/SDL.h>
#include <emscripten.h>

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;
int quit = 0;

// Main loop called by Emscripten
void main_loop(void) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_EVENT_QUIT) {
            quit = 1;
        }
    }

    if (quit) {
        emscripten_cancel_main_loop();
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return;
    }

    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
}

int main(int argc, char* argv[]) {
    SDL_SetHint(SDL_HINT_RENDER_VSYNC, "1");
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init Error: %s", SDL_GetError());
        return 1;
    }

    window = SDL_CreateWindow("Hello SDL3", 640, 480, SDL_WINDOW_RESIZABLE);
    if (!window) {
        SDL_Log("SDL_CreateWindow Error: %s", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    renderer = SDL_CreateRenderer(window, NULL);
    if (!renderer) {
        SDL_Log("SDL_CreateRenderer Error: %s", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    SDL_Log("Initialization complete, starting main loop.");
    emscripten_set_main_loop(main_loop, 0, 1);

    return 0;
}
