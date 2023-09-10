[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml)

# docker-sdl-compiler

Docker container [sdl2-compiler](https://hub.docker.com/repository/docker/hldtux/sdl2-compiler) with SDL2 + Tools to compile a C/C++ project.

### How to use

```shell
SDL_VERSION=2.28.3
SDL_PROJECT_PATH="~/my-sdl-project"
SDL_PROJECT_COMPILER_CMD="g++ main.cpp -o main -g `sdl2-config --cflags` `sdl2-config --static-libs`"
docker run -v $SDL_PROJECT_PATH:/tmp/workdir \
-w /tmp/workdir \
-ti hldtux:sdl2-compiler:$SDL_VERSION \
bash -c "$SDL_PROJECT_COMPILER_CMD"
```
