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
		hldtux/sdl-compiler-native:3.4.14 \
		bash -ic "${*:-exec bash}"
}

wasmc() {
	docker run --rm -it \
		-v "$PWD":/workdir \
		-w /workdir \
		hldtux/sdl-compiler-wasm:6.0.6 \
		bash -ic "${*:-exec bash}"
}
```

Native images export `$SDL_CFLAGS` and `$SDL_LIBS` for the installed SDL version.

```bash
cd samples
sdl1c 'g++ -I. sdl1/main.cpp -o sdl1/main -g $SDL_CFLAGS $SDL_LIBS'
sdl2c 'g++ -I. sdl2/main.cpp -o sdl2/main -g $SDL_CFLAGS $SDL_LIBS'
sdl3c 'g++ -I. sdl3/main.cpp -o sdl3/main -g $SDL_CFLAGS $SDL_LIBS'
wasmc 'emcc -I. emsdk/main-sdl1.cpp -o emsdk/sdl1.html -s USE_SDL=1 -s WASM=1'
wasmc 'emcc -I. emsdk/main-sdl2.cpp -o emsdk/sdl2.html -s USE_SDL=2 -s WASM=1'
wasmc 'emcc -I. emsdk/main-sdl3.cpp -o emsdk/sdl3.html -s USE_SDL=3 -s WASM=1'

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
SDL_VERSION=3.4.14

docker run --rm -ti \
  -v "$PWD/samples:/workdir" \
  -w /workdir \
  hldtux/sdl-compiler-native:$SDL_VERSION \
  bash -ic 'make sdl3'
```

## WebAssembly (Emscripten)

One image covers all SDL versions via `-s USE_SDL=`.

```bash
EMSDK_VERSION=6.0.6

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
