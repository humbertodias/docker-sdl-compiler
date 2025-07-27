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
    g++ \
    libgsl-dev \
    libncurses5-dev \
    libwebp-dev \
    meson \
    xutils-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    make \
    xterm \
    sudo \
    git \
    zip \
    curl \
    ca-certificates && \
    arch=$(dpkg --print-architecture) && \
    if [ "$arch" = "amd64" ]; then \
        apt install -y --no-install-recommends \
            gcc-mingw-w64-x86-64 \
            g++-mingw-w64-x86-64 \
            libreadline6-dev \
            valgrind \
            clang-format \
            mingw-w64 \
            mingw-w64-tools \
            gcc-multilib \
            g++-multilib; \
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
