#!/bin/bash

install_sdl1() {
	apt install -y --no-install-recommends \
		libsdl1.2-dev libsdl-ttf2.0-dev libsdl-image1.2-dev \
		libsdl-mixer1.2-dev libsdl-net1.2-dev
}

install_sdl2() {
	NAME=$1
	VERSION=$2
	NAME_WITHOUT_NUMBER=$(echo $NAME | sed -r 's/2//g')
	FOLDER_NAME=${NAME}-${VERSION}
	URL=https://github.com/libsdl-org/${NAME_WITHOUT_NUMBER}/releases/download/release-${VERSION}/${FOLDER_NAME}.tar.gz
	echo $URL
	NPROC=$(nproc)
	WORKDIR=$(mktemp -d --suffix=sdl)
	cd ${WORKDIR} &&
		curl -skL $URL | tar xvz --strip-components=1 &&
		./configure && make --jobs=${NPROC} && make --jobs=${NPROC} install &&
		rm -rf ${WORKDIR}
}

install_sdl3() {
	NAME=$1
	VERSION=$2
	NAME_WITHOUT_NUMBER=$(echo $NAME | sed -r 's/3//g')
	FOLDER_NAME=${NAME}-${VERSION}
	URL=https://github.com/libsdl-org/${NAME_WITHOUT_NUMBER}/releases/download/release-${VERSION}/${FOLDER_NAME}.tar.gz
	echo $URL
	NPROC=$(nproc)
	WORKDIR=$(mktemp -d --suffix=sdl)
	cd ${WORKDIR} &&
		curl -skL $URL | tar xvz --strip-components=1 &&
		cmake -DCMAKE_BUILD_TYPE=Release . &&
		cmake --build . --config Release --parallel ${NPROC}
	cmake --install . --config Release
	rm -rf ${WORKDIR}
}

install_sdl3_dependencies() {
	apt -y update && apt -y install --no-install-recommends \
		pkg-config cmake ninja-build libasound2-dev libpulse-dev \
		libaudio-dev libfribidi-dev libjack-dev libsndio-dev libx11-dev libxext-dev \
		libxrandr-dev libxcursor-dev libxfixes-dev libxi-dev libxss-dev libxtst-dev \
		libxkbcommon-dev libdrm-dev libgbm-dev libgl1-mesa-dev libgles2-mesa-dev \
		libegl1-mesa-dev libdbus-1-dev libibus-1.0-dev libudev-dev libthai-dev
}

install_build_dependencies() {
	apt update && apt install -y --no-install-recommends \
		build-essential cmake file gcc g++ make git zip curl ca-certificates \
		python3 pkg-config autoconf automake libtool \
		libgsl-dev libncurses5-dev libwebp-dev libfreetype6-dev libharfbuzz-dev \
		libpng-dev libjpeg-dev libogg-dev libvorbis-dev libflac-dev libmpg123-dev \
		libopus-dev meson xutils-dev && \
		arch=$(dpkg --print-architecture) && \
		if [ "$arch" = "amd64" ]; then \
			apt install -y --no-install-recommends \
				gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64 mingw-w64-tools \
				gcc-multilib g++-multilib; \
		fi
}

install_runtime_dependencies() {
	apt update && apt install -y --no-install-recommends \
		bash build-essential cmake pkg-config curl ca-certificates python3 file && \
		case "$SDL_VERSION" in \
			1.*) \
				apt install -y --no-install-recommends \
					libsdl1.2-dev libsdl-ttf2.0-dev libsdl-image1.2-dev \
					libsdl-mixer1.2-dev libsdl-net1.2-dev ;; \
			2.*) \
				apt install -y --no-install-recommends \
					libfreetype6-dev libharfbuzz-dev libpng-dev libjpeg-dev libwebp-dev \
					libogg-dev libvorbis-dev libflac-dev libmpg123-dev libopus-dev \
					libncurses5-dev libgsl-dev ;; \
			3.*) \
				apt install -y --no-install-recommends \
					libfreetype6-dev libharfbuzz-dev libpng-dev libjpeg-dev libwebp-dev \
					libogg-dev libvorbis-dev libflac-dev libmpg123-dev libopus-dev \
					libncurses5-dev libgsl-dev libasound2-dev libpulse-dev libaudio-dev \
					libfribidi-dev libjack-dev libsndio-dev libx11-dev libxext-dev \
					libxrandr-dev libxcursor-dev libxfixes-dev libxi-dev libxss-dev \
					libxtst-dev libxkbcommon-dev libdrm-dev libgbm-dev libgl1-mesa-dev \
					libgles2-mesa-dev libegl1-mesa-dev libdbus-1-dev libibus-1.0-dev \
					libudev-dev libthai-dev ;; \
		esac && \
		arch=$(dpkg --print-architecture) && \
		if [ "$arch" = "amd64" ]; then \
			apt install -y --no-install-recommends \
				gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64 mingw-w64-tools \
				gcc-multilib g++-multilib; \
		fi
}

cleanup_image() {
	apt remove --purge -y manpages man-db 2>/dev/null || true
	apt autoremove -y
	apt clean
	rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/share/locale /tmp/*
}
