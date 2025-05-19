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
SDL_VERSION=1.2
SDL_PROJECT=./samples/sdl1
docker run --rm -ti -v $SDL_PROJECT:/workdir -w /workdir hldtux/sdl-compiler:$SDL_VERSION \
bash -ic 'g++ main.cpp -o main -g `sdl-config --cflags --static-libs`'
```

SDL2
```shell
SDL_VERSION=2.32.4
SDL_PROJECT=./samples/sdl2
docker run --rm -ti -v $SDL_PROJECT:/workdir -w /workdir hldtux/sdl-compiler:$SDL_VERSION \
bash -ic 'g++ main.cpp -o main -g `sdl2-config --cflags --static-libs`'
```

SDL3
```shell
SDL_VERSION=3.2.14
SDL_PROJECT=./samples/sdl3
docker run --rm -ti -v $SDL_PROJECT:/workdir -w /workdir hldtux/sdl-compiler:$SDL_VERSION \
bash -ic 'g++ main.cpp -o main -g `pkg-config sdl3 --cflags --libs`'
```

emsdk - sdl2
```shell
SDL_VERSION=2.32.4
SDL_PROJECT=./samples/emsdk
docker run --rm -ti -v $SDL_PROJECT:/workdir -w /workdir sdl-compiler:$SDL_VERSION \
bash -ic 'emcc main-sdl2.cpp -o sdl2.html -s USE_SDL=2 -s WASM=1'
echo 'Access http://localhost:8000/sdl2.html' && python -m http.server -d $SDL_PROJECT
```

emsdk - sdl3
```shell
SDL_VERSION=3.2.14
SDL_PROJECT=./samples/emsdk
docker run --rm -ti -v $SDL_PROJECT:/workdir -w /workdir sdl-compiler:$SDL_VERSION \
bash -ic 'emcc main-sdl3.cpp -o sdl3.html -s USE_SDL=3 -s WASM=1 -sGL_ENABLE_GET_PROC_ADDRESS'
echo 'Access http://localhost:8000/sdl3.html' && python -m http.server -d $SDL_PROJECT
```