TARGET ?= native
VERSION ?= sdl2

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

ifeq ($(TARGET),wasm)
include .github/env/wasm.env
else
include .github/env/native/$(VERSION).env
endif
export

DOCKERFILE := Dockerfile.$(TARGET)

build:
ifeq ($(TARGET),wasm)
	docker build -f $(DOCKERFILE) . \
	--build-arg EMSDK_VERSION=${EMSDK_VERSION} \
	-t ${TAG_NAME} \
	--no-cache
else
	docker build -f $(DOCKERFILE) . \
	--build-arg SDL_VERSION=${SDL_VERSION} \
	--build-arg SDL_TTF_VERSION=${SDL_TTF_VERSION} \
	--build-arg SDL_IMAGE_VERSION=${SDL_IMAGE_VERSION} \
	--build-arg SDL_MIXER_VERSION=${SDL_MIXER_VERSION} \
	--build-arg SDL_NET_VERSION=${SDL_NET_VERSION} \
	-t ${TAG_NAME} \
	--no-cache
endif

build-all:
	$(MAKE) TARGET=native VERSION=sdl1 build
	$(MAKE) TARGET=native VERSION=sdl2 build
	$(MAKE) TARGET=native VERSION=sdl3 build
	$(MAKE) TARGET=wasm build

tag:
	docker tag ${TAG_NAME} ${DOCKERHUB_USERNAME}/${TAG_NAME}

login:
	docker login -u ${DOCKERHUB_USERNAME}

push: tag
	docker push ${DOCKERHUB_USERNAME}/${TAG_NAME}

shell: build
	docker run -v $(shell pwd):/tmp/workdir -w /tmp/workdir \
	-ti ${TAG_NAME} \
	bash

clean:
	docker ps -f name=${TAG_NAME} -qa | xargs docker rm -f
	docker image ls --filter 'reference=${TAG_NAME}' -qa | xargs docker rmi -f

format:
	shfmt -w fn-native.sh fn-wasm.sh
