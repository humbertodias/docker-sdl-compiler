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
	@ids=$$(docker images --format '{{.ID}} {{.Repository}}' \
		| awk '$$2 ~ /(^|\/)sdl-compiler-(native|wasm)$$/ { print $$1 }' \
		| sort -u); \
	if [ -n "$$ids" ]; then docker rmi -f $$ids; else echo 'No sdl-compiler images to remove'; fi

clean-all: clean

format:
	shfmt -w fn-native.sh fn-wasm.sh
