[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml)

# docker-sdl-compiler

Docker container [sdl-compiler](https://hub.docker.com/repository/docker/hldtux/sdl-compiler) with SDL 1/2 + [empscripten](https://emscripten.org/) + tools to compile a C/C++ project.

### How to use

```shell
SDL_VERSION=2.28.3
SDL_PROJECT_PATH="~/my-sdl-project"
SDL_PROJECT_COMPILER_CMD="g++ main.cpp -o main -g `sdl2-config --cflags --static-libs`"
docker run -v $SDL_PROJECT_PATH:/tmp/workdir \
-w /tmp/workdir \
-ti hldtux:sdl-compiler:$SDL_VERSION \
bash -c "$SDL_PROJECT_COMPILER_CMD"
```
