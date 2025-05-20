[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml)

# SDL Compiler Docker Image

A lightweight Docker image for **cross-compiling SDL applications**, supporting multiple SDL versions and targets such as native Linux, Windows (MinGW), and WebAssembly (Emscripten).

Docker Hub: [hldtux/sdl-compiler](https://hub.docker.com/r/hldtux/sdl-compiler)

## 🧩 Included Components

* [SDL 1.2](https://www.libsdl.org/)
* [SDL 2.x](https://www.libsdl.org/)
* [SDL 3.x](https://www.libsdl.org/)
* [Emscripten (emsdk)](https://emscripten.org/) – for compiling to WebAssembly
* [MinGW-w64](http://mingw-w64.org) – for cross-compiling to Windows
* Common C/C++ build tools (gcc, g++, make, etc.)

## 🚀 How to Use

Mount your project directory and run the desired build command. Below are examples for each SDL version and target.

### 🖥️ Native Compilation (Linux)

#### SDL 1.2

```bash
SDL_VERSION=1.2
SDL_PROJECT=./samples/sdl1

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  sdl-compiler:$SDL_VERSION \
  bash -ic 'g++ main.cpp -o main -g `sdl-config --cflags --static-libs`'
```

#### SDL 2.x

```bash
SDL_VERSION=2.32.4
SDL_PROJECT=./samples/sdl2

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler:$SDL_VERSION \
  bash -ic 'g++ main.cpp -o main -g `sdl2-config --cflags --static-libs`'
```

#### SDL 3.x

```bash
SDL_VERSION=3.2.14
SDL_PROJECT=./samples/sdl3

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler:$SDL_VERSION \
  bash -ic 'g++ main.cpp -o main -g `pkg-config sdl3 --cflags --libs`'
```

### 🌐 WebAssembly (Emscripten)

#### SDL 1.2 (Web)

```bash
SDL_VERSION=1.2
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler:$SDL_VERSION \
  bash -ic 'emcc main-sdl1.cpp -o sdl1.html -s USE_SDL=1 -s WASM=1'

echo 'Access http://localhost:8000/sdl1.html'
python -m http.server -d $SDL_PROJECT
```

#### SDL 2.x (Web)

```bash
SDL_VERSION=2.32.4
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler:$SDL_VERSION \
  bash -ic 'emcc main-sdl2.cpp -o sdl2.html -s USE_SDL=2 -s WASM=1'

echo 'Access http://localhost:8000/sdl2.html'
python -m http.server -d $SDL_PROJECT
```

#### SDL 3.x (Web)

```bash
SDL_VERSION=3.2.14
SDL_PROJECT=./samples/emsdk

docker run --rm -ti \
  -v $SDL_PROJECT:/workdir \
  -w /workdir \
  hldtux/sdl-compiler:$SDL_VERSION \
  bash -ic 'emcc main-sdl3.cpp -o sdl3.html -s USE_SDL=3 -s WASM=1'

echo 'Access http://localhost:8000/sdl3.html'
python -m http.server -d $SDL_PROJECT
```

## 🛠️ Building the Docker Image

If you want to build the image locally, follow the instructions in the [Docker build guide](./DOCKER.md).
