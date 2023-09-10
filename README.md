[![Deploy](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml/badge.svg)](https://github.com/humbertodias/docker-sdl-compiler/actions/workflows/deploy.yaml)

# docker-sdl-compiler

Container with SDL2 + Tools to compile a C/C++ project.

[hub.docker](https://hub.docker.com/repository/docker/hldtux/sdl2-compiler)


### How to use

```shell
YOUR_PROJECT_PATH=$(shell pwd)
SDL_VERSION=2.28.3
docker run -v $YOUR_PROJECT_PATH:/tmp/workdir \
-w /tmp/workdir \
-ti hldtux:sdl2-compiler:$SDL_VERSION \
bash
```
