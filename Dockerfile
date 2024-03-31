FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Update and install cross-platform build dependencies
RUN apt update && apt install -y \
    build-essential \
    cmake \
    file \
    gcc \
    g++ \
    g++-mingw-w64-x86-64 \
    libgsl-dev \
    libreadline6-dev \
    libsdl2-gfx-dev \
    libncurses5-dev \
    libwebp-dev \
    meson \
    mingw-w64 \
    mingw-w64-tools \
    xutils-dev

# Run architecture detection and install dependencies if architecture is amd64
RUN if [ "$(uname -m)" = "x86_64" ]; then apt install -y gcc-multilib g++-multilib ; else echo "Architecture is not amd64"; fi ;

# Install other dependencies
RUN apt install -y make xterm sudo build-essential git zip curl valgrind clang-format

# bash as default
SHELL ["/bin/bash", "-c"]

ARG SDL_VERSION=2.30.1
ARG SDL_TTF_VERSION=2.20.2
ARG SDL_IMAGE_VERSION=2.8.2
ARG SDL_MIXER_VERSION=2.8.0
ARG SDL_NET_VERSION=2.2.0

ADD fn.sh /
RUN source /fn.sh \
&& install_emsdk \
&& install_sdl1 \
&& install_sdl2 SDL2 ${SDL_VERSION} \
&& install_sdl2 SDL2_ttf ${SDL_TTF_VERSION} \
&& install_sdl2 SDL2_image ${SDL_IMAGE_VERSION} \
&& install_sdl2 SDL2_mixer ${SDL_MIXER_VERSION} \
&& install_sdl2 SDL2_net ${SDL_NET_VERSION}

EXPOSE 8080
