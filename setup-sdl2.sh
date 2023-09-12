#!/bin/bash

# apt install -y libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev

SDL_VERSION=${1:-2.28.3}
SDL_TTF_VERSION=${2:-2.20.2}
SDL_IMAGE_VERSION=${3:-2.6.3}
SDL_MIXER_VERSION=${4:-2.6.3}
SDL_NET_VERSION=${5:-2.2.0}

SDL_URL="https://github.com/libsdl-org/SDL/releases/download/release-${SDL_VERSION}/SDL2-${SDL_VERSION}.tar.gz"
curl -skL ${SDL_URL} -o SDL2-${SDL_VERSION}.tar.gz \
  && tar xf SDL2-${SDL_VERSION}.tar.gz \
  && cd SDL2-${SDL_VERSION} && ./configure && make && make install \
  && cd / && rm -rf /SDL2-${SDL_VERSION} SDL2-${SDL_VERSION}.tar.gz

SDL_TTF_URL="https://github.com/libsdl-org/SDL_ttf/releases/download/release-${SDL_TTF_VERSION}/SDL2_ttf-${SDL_TTF_VERSION}.tar.gz"
curl -skL ${SDL_TTF_URL} -o SDL2_ttf-${SDL_TTF_VERSION}.tar.gz \
  && tar xf SDL2_ttf-${SDL_TTF_VERSION}.tar.gz \
  && cd /SDL2_ttf-${SDL_TTF_VERSION} && ./configure && make && make install \
  && cd / && rm -rf /SDL2_ttf-${SDL_TTF_VERSION} SDL2_ttf-${SDL_TTF_VERSION}.tar.gz

SDL_IMAGE_URL="https://github.com/libsdl-org/SDL_image/releases/download/release-${SDL_IMAGE_VERSION}/SDL2_image-${SDL_IMAGE_VERSION}.tar.gz"
curl -skL ${SDL_IMAGE_URL} -o SDL2_image-${SDL_IMAGE_VERSION}.tar.gz \
  && tar xf SDL2_image-${SDL_IMAGE_VERSION}.tar.gz \
  && cd /SDL2_image-${SDL_IMAGE_VERSION} && ./configure && make && make install \
  && cd / && rm -rf /SDL2_image-${SDL_IMAGE_VERSION} SDL2_image-${SDL_IMAGE_VERSION}.tar.gz

SDL_MIXER_URL="https://github.com/libsdl-org/SDL_mixer/releases/download/release-${SDL_MIXER_VERSION}/SDL2_mixer-${SDL_MIXER_VERSION}.tar.gz"
curl -skL ${SDL_MIXER_URL} -o SDL2_mixer-${SDL_MIXER_VERSION}.tar.gz \
  && tar xf SDL2_mixer-${SDL_MIXER_VERSION}.tar.gz \
  && cd /SDL2_mixer-${SDL_MIXER_VERSION} && ./configure && make && make install \
  && cd / && rm -rf /SDL2_mixer-${SDL_MIXER_VERSION} SDL2_mixer-${SDL_MIXER_VERSION}.tar.gz

SDL_NET_URL="https://github.com/libsdl-org/SDL_net/releases/download/release-${SDL_NET_VERSION}/SDL2_net-${SDL_NET_VERSION}.tar.gz"
curl -skL ${SDL_NET_URL} -o SDL2_net-${SDL_NET_VERSION}.tar.gz \
  && tar xf SDL2_net-${SDL_NET_VERSION}.tar.gz \
  && cd /SDL2_net-${SDL_NET_VERSION} && ./configure && make && make install \
  && cd / && rm -rf /SDL2_net-${SDL_NET_VERSION} SDL2_net-${SDL_NET_VERSION}.tar.gz
