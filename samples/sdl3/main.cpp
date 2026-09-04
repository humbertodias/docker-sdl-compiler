#include "sdl.h"
#include "hello_common.h"

static void fill_surface(void* ctx, int x, int y, int w, int h, unsigned color) {
    SDL_Surface* s = (SDL_Surface*)ctx;
    SDL_Rect r = {x, y, w, h};
    SDL_FillSurfaceRect(s, &r, color);
}

static SDL_Texture* create_hello_card(SDL_Renderer* r) {
    SDL_Surface* surface = SDL_CreateSurface(HELLO_CARD_W, HELLO_CARD_H, SDL_PIXELFORMAT_RGBA32);
    if (!surface) {
        return NULL;
    }

    const SDL_PixelFormatDetails* fmt = SDL_GetPixelFormatDetails(surface->format);
    unsigned bg = SDL_MapRGBA(fmt, NULL, 255, 255, 255, 255);
    unsigned border = SDL_MapRGBA(fmt, NULL, 30, 30, 30, 255);
    unsigned text = SDL_MapRGBA(fmt, NULL, 20, 20, 20, 255);
    int ver = SDL_GetVersion();
    hello_paint_card(
        fill_surface, surface, bg, border, text,
        SDL_VERSIONNUM_MAJOR(ver),
        SDL_VERSIONNUM_MINOR(ver),
        SDL_VERSIONNUM_MICRO(ver)
    );

    SDL_Texture* texture = SDL_CreateTextureFromSurface(r, surface);
    SDL_DestroySurface(surface);
    return texture;
}

static void present(SDL_Renderer* renderer, SDL_Texture* card) {
    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);

    SDL_FRect dst = {
        (float)(HELLO_SCREEN_W - HELLO_CARD_W) / 2.0f,
        (float)(HELLO_SCREEN_H - HELLO_CARD_H) / 2.0f,
        (float)HELLO_CARD_W,
        (float)HELLO_CARD_H
    };
    SDL_RenderTexture(renderer, card, NULL, &dst);
    SDL_RenderPresent(renderer);
}

int main(int argc, char* argv[]) {
    (void)argc;
    (void)argv;

    SDL_SetHint(SDL_HINT_RENDER_VSYNC, "1");
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init Error: %s", SDL_GetError());
        return 1;
    }

    SDL_Window* window = SDL_CreateWindow("Hello SDL3", HELLO_SCREEN_W, HELLO_SCREEN_H, 0);
    if (!window) {
        SDL_Log("SDL_CreateWindow Error: %s", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    SDL_Renderer* renderer = SDL_CreateRenderer(window, NULL);
    if (!renderer) {
        SDL_Log("SDL_CreateRenderer Error: %s", SDL_GetError());
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

    SDL_SetRenderVSync(renderer, 1);

    int quit = 0;
    SDL_Event event;
    while (!quit) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_EVENT_QUIT) {
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
