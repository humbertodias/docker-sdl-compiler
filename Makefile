SDL_VERSION=2.28.3
SDL_TTF_VERSION=2.20.2
SDL_IMAGE_VERSION=2.6.3
SDL_MIXER_VERSION=2.6.3
TAG_NAME=sdl2-compiler
DOCKERHUB_USERNAME=hldtux

build:
	docker build . \
	--build-arg SDL_VERSION=${SDL_VERSION} \
	--build-arg SDL_TTF_VERSION=${SDL_TTF_VERSION} \
	--build-arg SDL_IMAGE_VERSION=${SDL_IMAGE_VERSION} \
	--build-arg SDL_MIXER_VERSION=${SDL_MIXER_VERSION} \
	-t ${TAG_NAME}:${SDL_VERSION}

tag:
	docker tag ${TAG_NAME}:${SDL_VERSION} ${DOCKERHUB_USERNAME}/${TAG_NAME}:${SDL_VERSION}

login:
	docker login -u ${DOCKERHUB_USERNAME}

push: 	tag
	docker push ${DOCKERHUB_USERNAME}/${TAG_NAME}:${SDL_VERSION}

run-it:	docker-build
	docker run -v $(shell pwd):/tmp/workdir -w /tmp/workdir \
	-ti ${TAG_NAME}:${SDL_VERSION} \
	bash

clean:
	docker ps -f name=${TAG_NAME} -qa | xargs docker rm -f
	docker image ls --filter 'reference=${TAG_NAME}' -qa | xargs docker rmi -f
