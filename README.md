# docker-sdl-compiler

Container with SDL2 + Tools to compile a C/C++ project.

[hub.docker](https://hub.docker.com/repository/docker/hldtux/sdl2-compiler)


### How to use

```shell
YOUR_PROJECT_PATH=$(shell pwd)
docker run -v $YOUR_PROJECT_PATH:/tmp/workdir \
-w /tmp/workdir \
-ti hldtux:sdl2-compiler:2.28.3 \
bash
```