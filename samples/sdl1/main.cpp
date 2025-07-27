#include <SDL/SDL.h>
#define SDL_Log(...) printf(__VA_ARGS__)

int main(int argc, char *argv[])
{
    if (SDL_Init(SDL_INIT_VIDEO) < 0)
    {
        SDL_Log("Unable to init SDL: %s", SDL_GetError());
        return 1;
    }

    atexit(SDL_Quit);

    SDL_Surface *screen = SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE);
    if (!screen)
    {
        SDL_Log("Unable to set video mode: %s", SDL_GetError());
        return 1;
    }

    SDL_FillRect(screen, NULL, SDL_MapRGB(screen->format, 0, 0, 0));
    SDL_Flip(screen);

    int running = 1;
    SDL_Event event;
    while (running)
    {
        while (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT)
            {
                running = 0;
            }
        }
        SDL_Delay(10);
    }

    return 0;
}
