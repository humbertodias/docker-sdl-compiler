#!/bin/bash

# apt install -y libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev

SDL_VERSION=${1:-2.28.3}
SDL_TTF_VERSION=${2:-2.20.2}
SDL_IMAGE_VERSION=${3:-2.6.3}
SDL_MIXER_VERSION=${4:-2.6.3}
SDL_NET_VERSION=${5:-2.2.0}

install_sdl(){
NAME=$1
VERSION=$2
NAME_WITHOUT_NUMBER=$(echo $NAME | sed -r 's/2//g')
FOLDER_NAME=${NAME}-${VERSION}
URL=https://github.com/libsdl-org/${NAME_WITHOUT_NUMBER}/releases/download/release-${VERSION}/${FOLDER_NAME}.tar.gz
echo $URL
curl -o /tmp/${FOLDER_NAME}.tar.gz -skL $URL  \
  && tar xf /tmp/${FOLDER_NAME}.tar.gz \
  && cd ${FOLDER_NAME} && ./configure && make && make install \
  && rm -rf /tmp/${FOLDER_NAME} /tmp/${FOLDER_NAME}.tar.gz
}

install_sdl SDL2 $SDL_VERSION
install_sdl SDL2_ttf $SDL_TTF_VERSION
install_sdl SDL2_image $SDL_IMAGE_VERSION
install_sdl SDL2_mixer $SDL_MIXER_VERSION
install_sdl SDL2_net $SDL_NET_VERSION