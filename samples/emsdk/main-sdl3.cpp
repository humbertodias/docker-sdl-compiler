#include <SDL3/SDL.h>
#include <emscripten.h>
#include "hello_common.h"

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;
SDL_Texture* card = NULL;
int card_w = 0;
int card_h = 0;
int quit = 0;

static void fill_surface(void* ctx, int x, int y, int w, int h, unsigned color) {
    SDL_Surface* s = (SDL_Surface*)ctx;
    SDL_Rect r = {x, y, w, h};
    SDL_FillSurfaceRect(s, &r, color);
}

static SDL_Texture* create_hello_card(SDL_Renderer* r) {
    int ver = SDL_GetVersion();
    HelloLibVersion libs[] = {
        {"SDL", SDL_VERSIONNUM_MAJOR(ver), SDL_VERSIONNUM_MINOR(ver), SDL_VERSIONNUM_MICRO(ver)},
    };
    const int nlibs = (int)(sizeof(libs) / sizeof(libs[0]));
    const int card_h = hello_card_height(nlibs);

    SDL_Surface* surface = SDL_CreateSurface(HELLO_CARD_W, card_h, SDL_PIXELFORMAT_RGBA32);
    if (!surface) {
        return NULL;
    }

    const SDL_PixelFormatDetails* fmt = SDL_GetPixelFormatDetails(surface->format);
    unsigned bg = SDL_MapRGBA(fmt, NULL, 255, 255, 255, 255);
    unsigned border = SDL_MapRGBA(fmt, NULL, 30, 30, 30, 255);
    unsigned text = SDL_MapRGBA(fmt, NULL, 20, 20, 20, 255);
    hello_paint_card(fill_surface, surface, bg, border, text, libs, nlibs);

    SDL_Texture* texture = SDL_CreateTextureFromSurface(r, surface);
    SDL_DestroySurface(surface);
    return texture;
}

void main_loop(void) {
    if (!renderer || !card) {
        return;
    }

    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_EVENT_QUIT) {
            quit = 1;
        }
    }

    if (quit) {
        emscripten_cancel_main_loop();
        SDL_DestroyTexture(card);
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return;
    }

    SDL_SetRenderDrawColor(renderer, 0, 128, 255, 255);
    SDL_RenderClear(renderer);

    SDL_FRect dst = {
        (float)(HELLO_SCREEN_W - card_w) / 2.0f,
        (float)(HELLO_SCREEN_H - card_h) / 2.0f,
        (float)card_w,
        (float)card_h
    };
    SDL_RenderTexture(renderer, card, NULL, &dst);
    SDL_RenderPresent(renderer);
}

int main(int argc, char* argv[]) {
    SDL_SetHint(SDL_HINT_RENDER_VSYNC, "1");
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init Error: %s", SDL_GetError());
        return 1;
    }

    emscripten_set_main_loop(main_loop, 0, 0);

    window = SDL_CreateWindow("Hello SDL3 + Emscripten", HELLO_SCREEN_W, HELLO_SCREEN_H, SDL_WINDOW_RESIZABLE);
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

    card = create_hello_card(renderer);
    if (!card) {
        SDL_Log("Failed to create hello card");
        return 1;
    }

    float tw = 0.0f;
    float th = 0.0f;
    SDL_GetTextureSize(card, &tw, &th);
    card_w = (int)tw;
    card_h = (int)th;

    SDL_SetRenderVSync(renderer, 1);
    emscripten_set_main_loop_timing(EM_TIMING_RAF, 0);
    return 0;
}
