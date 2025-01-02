[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml)

# SDL-Compiler

Docker container [sdl-compiler](https://hub.docker.com/r/hldtux/sdl-compiler) to cross-compiling SDL application that contains:
* [SDL 1.x](https://www.libsdl.org/)
* [SDL 2.x](https://www.libsdl.org/)
* [SDL 3.x](https://www.libsdl.org/)
* [empscripten](https://emscripten.org/)
* [mingw](http://mingw-w64.org)
* Tools to compile a C/C++ project


### How to use

```shell
SDL_VERSION=2.30.2
SDL_PROJECT_PATH="~/my-sdl-project"
SDL_PROJECT_COMPILER_CMD="g++ main.cpp -o main -g `sdl2-config --cflags --static-libs`"
docker run -v $SDL_PROJECT_PATH:/tmp/workdir \
-w /tmp/workdir \
-ti hldtux/sdl-compiler:$SDL_VERSION \
bash -c "$SDL_PROJECT_COMPILER_CMD"
```

SDL3
```shell
SDL3_VERSION=3.1.6
SDL_PROJECT_PATH="~/my-sdl-project"
SDL_PROJECT_COMPILER_CMD="g++ main.cpp -o main -g `pkg-config sdl3 --cflags --libs`"
docker run -v $SDL_PROJECT_PATH:/tmp/workdir \
-w /tmp/workdir \
-ti hldtux/sdl-compiler:$SDL_VERSION \
bash -c "$SDL_PROJECT_COMPILER_CMD"
```

