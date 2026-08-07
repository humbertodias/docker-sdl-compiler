## Building and Pushing Containers

Images are split into **native** (Linux/MinGW) and **wasm** (Emscripten) variants.

### Native (SDL + MinGW)

```sh
make TARGET=native VERSION=sdl1
make TARGET=native VERSION=sdl2
make TARGET=native VERSION=sdl3
make TARGET=native VERSION=sdl2 push
```

### WebAssembly (Emscripten)

```sh
make TARGET=wasm VERSION=sdl1
make TARGET=wasm VERSION=sdl2
make TARGET=wasm VERSION=sdl3
make TARGET=wasm VERSION=sdl2 push
```

### Build all variants

```sh
make build-all
```
