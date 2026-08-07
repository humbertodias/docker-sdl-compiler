## Building and Pushing Containers

Images are split into **native** (Linux/MinGW, per SDL version) and **wasm** (Emscripten, per emsdk version).

### Native (SDL + MinGW)

```sh
make TARGET=native VERSION=sdl1
make TARGET=native VERSION=sdl2
make TARGET=native VERSION=sdl3
make TARGET=native VERSION=sdl2 push
```

### WebAssembly (Emscripten)

One image for all SDL ports (`-s USE_SDL=1/2/3`), tagged by emsdk version:

```sh
make TARGET=wasm
make TARGET=wasm push
```

### Build all variants

```sh
make build-all
```
