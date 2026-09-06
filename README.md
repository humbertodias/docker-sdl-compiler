[![ci](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/ci.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/ci.yml)
[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yml)
[![Docker native Pulls](https://img.shields.io/docker/pulls/hldtux/sdl-compiler-native.svg?logo=docker)](https://hub.docker.com/r/hldtux/sdl-compiler-native)
[![Docker wasm Pulls](https://img.shields.io/docker/pulls/hldtux/sdl-compiler-wasm.svg?logo=docker)](https://hub.docker.com/r/hldtux/sdl-compiler-wasm)


# SDL Compiler Docker Image

Docker images for **cross-compiling SDL applications**, split by target:

| Image | Purpose | Tags |
|---|---|---|
| [`hldtux/sdl-compiler-native`](https://hub.docker.com/r/hldtux/sdl-compiler-native) | Native Linux + MinGW (static SDL) | SDL version (`1.2.15`, `2.32.10`, `3.4.16`) |
| [`hldtux/sdl-compiler-wasm`](https://hub.docker.com/r/hldtux/sdl-compiler-wasm) | WebAssembly via Emscripten | emsdk version (`6.0.9`) |

## Included Components

**Native:** SDL 1.2 / 2.x / 3.x (static) plus ttf/image/mixer/net/gfx, MinGW-w64, gcc/g++/make

**Wasm:** Emscripten SDK (`emcc`), SDL ports via `-s USE_SDL=1/2/3` (SDL2 also ttf/image/mixer/net; SDL3 also ttf)

## Shell aliases

Source once (or add to `~/.bashrc`):

```bash
sdl1c() {
	docker run --rm -it \
		-v "$PWD":/workdir \
		-w /workdir \
		hldtux/sdl-compiler-native:1.2.15 \
		bash -ic "${*:-exec bash}"
}

sdl2c() {
	docker run --rm -it \
		-v "$PWD":/workdir \
		-w /workdir \
		hldtux/sdl-compiler-native:2.32.10 \
		bash -ic "${*:-exec bash}"
}

sdl3c() {
	docker run --rm -it \
		-v "$PWD":/workdir \
		-w /workdir \
		hldtux/sdl-compiler-native:3.4.16 \
		bash -ic "${*:-exec bash}"
}

wasmc() {
	docker run --rm -it \
		-v "$PWD":/workdir \
		-w /workdir \
		hldtux/sdl-compiler-wasm:6.0.9 \
		bash -ic "${*:-exec bash}"
}
```

Native images export `$SDL_CFLAGS` and `$SDL_LIBS` for the installed SDL version.

```bash
cd samples
sdl1c 'g++ -I. sdl1/main.cpp -o sdl1/main -g `pkg-config --static --cflags --libs sdl`'
sdl2c 'g++ -I. sdl2/main.cpp -o sdl2/main -g `pkg-config --static --cflags --libs sdl2`'
sdl3c 'g++ -I. sdl3/main.cpp -o sdl3/main -g `pkg-config --static --cflags --libs sdl3`'
wasmc 'emcc -I. emsdk/main-sdl1.cpp -o emsdk/sdl1.html -s USE_SDL=1 -s WASM=1'
wasmc 'emcc -I. emsdk/main-sdl2.cpp -o emsdk/sdl2.html -s WASM=1 -s USE_SDL=2 -s USE_SDL_TTF=2 -s USE_SDL_IMAGE=2 -s USE_SDL_MIXER=2 -s USE_SDL_NET=2'
wasmc 'emcc -I. emsdk/main-sdl3.cpp -o emsdk/sdl3.html -s WASM=1 -s USE_SDL=3 -s USE_SDL_TTF=3'

sdl2c   # interactive shell in the container
```

## Native Compilation (Linux)

Mount `samples/` so shared `hello_common.h` is visible (`-I.`).

#### SDL 1.2

```bash
SDL_VERSION=1.2.15

docker run --rm -ti \
  -v "$PWD/samples:/workdir" \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'make sdl1'
```

#### SDL 2.x

```bash
SDL_VERSION=2.32.10

docker run --rm -ti \
  -v "$PWD/samples:/workdir" \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'make sdl2'
```

#### SDL 3.x

```bash
SDL_VERSION=3.4.16

docker run --rm -ti \
  -v "$PWD/samples:/workdir" \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'make sdl3'
```

## WebAssembly (Emscripten)

One image covers all SDL versions. SDL2 also pulls ttf/image/mixer/net ports; SDL3 pulls ttf. There is no SDL1 satellite port in this emsdk.

```bash
EMSDK_VERSION=6.0.9

docker run --rm -ti \
  -v "$PWD/samples:/workdir" \
  -w /workdir \
  hldtux/sdl-compiler-wasm:$EMSDK_VERSION \
  bash -ic 'make wasm'

echo 'Access http://localhost:8000/'
python -m http.server -d samples/emsdk
```

## Building Locally

See the [Docker build guide](./DOCKER.md).
