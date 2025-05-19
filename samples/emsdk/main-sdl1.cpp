#include <SDL/SDL.h>
#include <stdio.h>
#include <emscripten.h>

SDL_Surface* screen;

// This function is called every frame
void main_loop(void) {
    // Fill the screen with a solid color (RGB: 0, 128, 255)
    Uint32 color = SDL_MapRGB(screen->format, 0, 128, 255);
    SDL_FillRect(screen, NULL, color);

    // Update the screen with the new color
    SDL_Flip(screen);
}

int main() {
    // Initialize SDL with video subsystem
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }

    // Create a window with a 640x480 resolution
    screen = SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE);
    if (!screen) {
        printf("SDL_SetVideoMode failed: %s\n", SDL_GetError());
        return 1;
    }

    // Set window title
    SDL_WM_SetCaption("Hello SDL1 + Emscripten", NULL);

    // Start the main loop (Emscripten will call main_loop() repeatedly)
    emscripten_set_main_loop(main_loop, 0, 1);

    // SDL_Quit will never be called in Emscripten (infinite loop)
    return 0;
}
