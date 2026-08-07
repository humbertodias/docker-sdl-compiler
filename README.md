[![ci](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/ci.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/ci.yml)
[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml)
[![Docker native Pulls](https://img.shields.io/docker/pulls/hldtux/sdl-compiler-native.svg?logo=docker)](https://hub.docker.com/r/hldtux/sdl-compiler-native)
[![Docker wasm Pulls](https://img.shields.io/docker/pulls/hldtux/sdl-compiler-wasm.svg?logo=docker)](https://hub.docker.com/r/hldtux/sdl-compiler-wasm)


# SDL Compiler Docker Image

Docker images for **cross-compiling SDL applications**, split by target:

| Image | Purpose | Tags |
|---|---|---|
| [`hldtux/sdl-compiler-native`](https://hub.docker.com/r/hldtux/sdl-compiler-native) | Native Linux + MinGW (static SDL) | SDL version (`1.2.15`, `2.32.10`, `3.4.14`) |
| [`hldtux/sdl-compiler-wasm`](https://hub.docker.com/r/hldtux/sdl-compiler-wasm) | WebAssembly via Emscripten | emsdk version (`6.0.6`) |

## Included Components

**Native:** SDL 1.2 / 2.x / 3.x (static), MinGW-w64, gcc/g++/make

**Wasm:** Emscripten SDK (`emcc`), SDL ports via `-s USE_SDL=1/2/3`

## Native Compilation (Linux)

#### SDL 1.2

```bash
SDL_VERSION=1.2.15
SDL_PROJECT=./samples/sdl1

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'g++ main.cpp -o main -g `sdl-config --cflags --static-libs`'
```

#### SDL 2.x

```bash
SDL_VERSION=2.32.10
SDL_PROJECT=./samples/sdl2

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'g++ main.cpp -o main -g `sdl2-config --cflags --static-libs`'
```

#### SDL 3.x

```bash
SDL_VERSION=3.4.14
SDL_PROJECT=./samples/sdl3

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'g++ main.cpp -o main -g `pkg-config sdl3 --cflags --libs`'
```

## WebAssembly (Emscripten)

One image covers all SDL versions via `-s USE_SDL=`.

```bash
EMSDK_VERSION=6.0.6
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$EMSDK_VERSION \
  bash -ic 'emcc main-sdl1.cpp -o sdl1.html -s USE_SDL=1 -s WASM=1'

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$EMSDK_VERSION \
  bash -ic 'emcc main-sdl2.cpp -o sdl2.html -s USE_SDL=2 -s WASM=1'

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$EMSDK_VERSION \
  bash -ic 'emcc main-sdl3.cpp -o sdl3.html -s USE_SDL=3 -s WASM=1'

echo 'Access http://localhost:8000/'
python -m http.server -d $SDL_PROJECT
```

## Building Locally

See the [Docker build guide](./DOCKER.md).
