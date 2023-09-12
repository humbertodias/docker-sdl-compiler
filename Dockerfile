FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Update and install cross-platform build dependencies
RUN apt update && apt install -y \
    gcc \
    g++ \
    gcc-multilib \
    g++-multilib \
    build-essential \
    xutils-dev \
    libreadline6-dev \
    libncurses5-dev \
    mingw-w64 \
    mingw-w64-tools \
    g++-mingw-w64-x86-64 \
    libwebp-dev \
    libgsl-dev \
    libsdl2-gfx-dev \
    cmake \
    file    

# Install other dependencies
RUN apt install -y make xterm sudo build-essential git zip curl valgrind clang-format

ARG SDL_VERSION=2.28.3
ARG SDL_TTF_VERSION=2.20.2
ARG SDL_IMAGE_VERSION=2.6.3
ARG SDL_MIXER_VERSION=2.6.3
ARG SDL_NET_VERSION=2.2.0

ADD setup-*.sh /
RUN bash setup-sdl1.sh
RUN bash setup-sdl2.sh ${SDL_VERSION} ${SDL_TTF_VERSION} ${SDL_IMAGE_VERSION} ${SDL_MIXER_VERSION} ${SDL_NET_VERSION}

# emcc
RUN \
cd /opt && \
# Get the emsdk repo
git clone https://github.com/emscripten-core/emsdk.git && \
# Enter that directory
cd emsdk && \
# Fetch the latest version of the emsdk (not needed the first time you clone)
git pull && \
# Download and install the latest SDK tools.
./emsdk install latest && \
# Make the "latest" SDK "active" for the current user. (writes .emscripten file)
./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
RUN echo "source /opt/emsdk/emsdk_env.sh" >> ~/.profile

EXPOSE 8080
