[![ci](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/ci.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/ci.yml)
[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/hldtux/sdl-compiler-native.svg)](https://hub.docker.com/r/hldtux/sdl-compiler-native)


# SDL Compiler Docker Image

Docker images for **cross-compiling SDL applications**, split by target:

| Image | Purpose |
|---|---|
| [`hldtux/sdl-compiler-native`](https://hub.docker.com/r/hldtux/sdl-compiler-native) | Native Linux + MinGW (static SDL) |
| [`hldtux/sdl-compiler-wasm`](https://hub.docker.com/r/hldtux/sdl-compiler-wasm) | WebAssembly via Emscripten |

## Included Components

**Native:** SDL 1.2 / 2.x / 3.x (static), MinGW-w64, gcc/g++/make

**Wasm:** Emscripten SDK (`emcc`), SDL ports via `-s USE_SDL=1/2/3`

## Native Compilation (Linux)

#### SDL 1.2

```bash
SDL_VERSION=1.2
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

#### SDL 1.2 (Web)

```bash
SDL_VERSION=1.2
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$SDL_VERSION \
  bash -ic 'emcc main-sdl1.cpp -o sdl1.html -s USE_SDL=1 -s WASM=1'

echo 'Access http://localhost:8000/sdl1.html'
python -m http.server -d $SDL_PROJECT
```

#### SDL 2.x (Web)

```bash
SDL_VERSION=2.32.10
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$SDL_VERSION \
  bash -ic 'emcc main-sdl2.cpp -o sdl2.html -s USE_SDL=2 -s WASM=1'

echo 'Access http://localhost:8000/sdl2.html'
python -m http.server -d $SDL_PROJECT
```

#### SDL 3.x (Web)

```bash
SDL_VERSION=3.4.14
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$SDL_VERSION \
  bash -ic 'emcc main-sdl3.cpp -o sdl3.html -s USE_SDL=3 -s WASM=1'

echo 'Access http://localhost:8000/sdl3.html'
python -m http.server -d $SDL_PROJECT
```

## Building Locally

See the [Docker build guide](./DOCKER.md).
