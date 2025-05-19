[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml)

# SDL-Compiler

Docker container [sdl-compiler](https://hub.docker.com/r/hldtux/sdl-compiler) to cross-compiling SDL application that contains:
* [SDL 1.x](https://www.libsdl.org/)
* [SDL 2.x](https://www.libsdl.org/)
* [SDL 3.x](https://www.libsdl.org/)
* [empscripten](https://emscripten.org/)
* [mingw](http://mingw-w64.org)
* Tools to compile a C/C++ project


### How to use

SDL1
```shell
cd samples/sdl1
SDL_VERSION=1.2 docker run --rm -ti -v $PWD:/workdir -w /workdir hldtux/sdl-compiler:$SDL_VERSION \
bash -c 'g++ main.cpp -o main -g `sdl-config --cflags --static-libs`'
```

SDL2
```shell
cd samples/sdl2
SDL_VERSION=2.32.4 docker run --rm -ti -v $PWD:/workdir -w /workdir hldtux/sdl-compiler:$SDL_VERSION \
bash -c 'g++ main.cpp -o main -g `sdl2-config --cflags --static-libs`'
```

SDL3
```shell
cd samples/sdl3
SDL_VERSION=3.2.10 docker run --rm -ti -v $PWD:/workdir -w /workdir hldtux/sdl-compiler:$SDL_VERSION \
bash -c 'g++ main.cpp -o main -g `pkg-config sdl3 --cflags --libs`'
```

