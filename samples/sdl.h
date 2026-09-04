#pragma once

#if defined(SDL3)

    #include <SDL3/SDL.h>

#elif defined(SDL2)

    #include <SDL2/SDL.h>

#elif defined(SDL1)

    #include <SDL/SDL.h>

#else

    #error "SDL version not defined"

#endif
