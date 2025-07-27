FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Sao_Paulo \
    EMSDK_QUIET=1

# Install essential and cross-platform build dependencies
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    cmake \
    file \
    gcc \
    gcc-mingw-w64-x86-64 \
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
    xutils-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    make \
    xterm \
    sudo \
    git \
    zip \
    curl \
    ca-certificates \
    valgrind \
    clang-format && \
    # Install 32-bit libs if architecture is amd64
    if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        apt install -y --no-install-recommends gcc-multilib g++-multilib; \
    fi

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# SDL version arguments
ARG SDL_VERSION
ARG SDL_TTF_VERSION
ARG SDL_IMAGE_VERSION
ARG SDL_MIXER_VERSION
ARG SDL_NET_VERSION
ARG EMSDK_VERSION

# Add custom helper script
ADD fn.sh /

# Install emsdk and SDL libraries
RUN source /fn.sh && \
    install_emsdk ${EMSDK_VERSION} && \
    case "$SDL_VERSION" in \
        1.*) \
            install_sdl1 ;; \
        2.*) \
            install_sdl2 SDL2 ${SDL_VERSION} && \
            install_sdl2 SDL2_ttf ${SDL_TTF_VERSION} && \
            install_sdl2 SDL2_image ${SDL_IMAGE_VERSION} && \
            install_sdl2 SDL2_mixer ${SDL_MIXER_VERSION} && \
            install_sdl2 SDL2_net ${SDL_NET_VERSION} ;; \
        3.*) \
            install_sdl3 SDL3 ${SDL_VERSION} && \
            install_sdl3 SDL3_ttf ${SDL_TTF_VERSION} && \
            install_sdl3 SDL3_image ${SDL_IMAGE_VERSION} ;; \
    esac

# Clean up
RUN apt remove --purge -y manpages man-db && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/share/locale /tmp/*

EXPOSE 8080
