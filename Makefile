SDL_VERSION=2.30.1
SDL_TTF_VERSION=2.20.2
SDL_IMAGE_VERSION=2.8.2
SDL_MIXER_VERSION=2.8.0
SDL_NET_VERSION=2.2.0
DOCKERHUB_USERNAME=hldtux
TAG_NAME=sdl-compiler:${SDL_VERSION}

build:
	docker build . \
	--build-arg SDL_VERSION=${SDL_VERSION} \
	--build-arg SDL_TTF_VERSION=${SDL_TTF_VERSION} \
	--build-arg SDL_IMAGE_VERSION=${SDL_IMAGE_VERSION} \
	--build-arg SDL_MIXER_VERSION=${SDL_MIXER_VERSION} \
	--build-arg SDL_NET_VERSION=${SDL_NET_VERSION} \
	-t ${TAG_NAME}

tag:
	docker tag ${TAG_NAME} ${DOCKERHUB_USERNAME}/${TAG_NAME}

login:
	docker login -u ${DOCKERHUB_USERNAME}

push: 	tag
	docker push ${DOCKERHUB_USERNAME}/${TAG_NAME}

shell:	build
	docker run -v $(shell pwd):/tmp/workdir -w /tmp/workdir \
	-ti ${TAG_NAME} \
	bash

clean:
	docker ps -f name=${TAG_NAME} -qa | xargs docker rm -f
	docker image ls --filter 'reference=${TAG_NAME}' -qa | xargs docker rmi -f

format:
	shfmt -w fn.sh
