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

	EXTRA_CONFIG="--disable-shared --enable-static"
	case "$NAME" in
	SDL2_ttf)
		# Avoid embedding FreeType/HarfBuzz into libSDL2_ttf.a (~100MB+).
		EXTRA_CONFIG="$EXTRA_CONFIG --disable-freetype-builtin --disable-harfbuzz-builtin"
		;;
	esac

	cd ${WORKDIR} &&
		curl -skL $URL | tar xvz --strip-components=1 &&
		./configure ${EXTRA_CONFIG} CFLAGS="-Os -g0" CXXFLAGS="-Os -g0" &&
		make --jobs=${NPROC} && make --jobs=${NPROC} install &&
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

	EXTRA_CMAKE="-DSDL_SHARED=OFF -DSDL_STATIC=ON -DBUILD_SHARED_LIBS=OFF"
	case "$NAME" in
	SDL3_ttf)
		EXTRA_CMAKE="$EXTRA_CMAKE -DSDLTTF_VENDORED=OFF -DSDLTTF_HARFBUZZ=ON -DSDLTTF_FREETYPE=ON"
		;;
	SDL3_image)
		EXTRA_CMAKE="$EXTRA_CMAKE -DSDLIMAGE_VENDORED=OFF"
		;;
	SDL3_mixer)
		EXTRA_CMAKE="$EXTRA_CMAKE -DSDLMIXER_VENDORED=OFF"
		;;
	esac

	cd ${WORKDIR} &&
		curl -skL $URL | tar xvz --strip-components=1 &&
		cmake -DCMAKE_BUILD_TYPE=MinSizeRel ${EXTRA_CMAKE} . &&
		cmake --build . --config MinSizeRel --parallel ${NPROC}
	cmake --install . --config MinSizeRel
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
		g++ make cmake file git curl ca-certificates \
		pkg-config autoconf automake libtool \
		libwebp-dev libfreetype6-dev libharfbuzz-dev \
		libpng-dev libjpeg-dev libogg-dev libvorbis-dev libflac-dev libmpg123-dev \
		libopus-dev && \
		arch=$(dpkg --print-architecture) && \
		if [ "$arch" = "amd64" ]; then \
			apt install -y --no-install-recommends \
				gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64 mingw-w64-tools \
				gcc-multilib g++-multilib; \
		fi
}

install_runtime_dependencies() {
	# Keep a minimal toolchain + libs required for static SDL linking.
	apt update && apt install -y --no-install-recommends \
		bash g++ make pkg-config ca-certificates && \
		case "$SDL_VERSION" in \
			1.*) \
				apt install -y --no-install-recommends \
					libsdl1.2-dev libsdl-ttf2.0-dev libsdl-image1.2-dev \
					libsdl-mixer1.2-dev libsdl-net1.2-dev ;; \
			2.*) \
				apt install -y --no-install-recommends \
					libfreetype6-dev libharfbuzz-dev libpng-dev libjpeg-dev libwebp-dev \
					libogg-dev libvorbis-dev libflac-dev libmpg123-dev libopus-dev ;; \
			3.*) \
				apt install -y --no-install-recommends \
					libfreetype6-dev libharfbuzz-dev libpng-dev libjpeg-dev libwebp-dev \
					libogg-dev libvorbis-dev libflac-dev libmpg123-dev libopus-dev \
					libasound2-dev libpulse-dev libaudio-dev \
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

slim_installed_sdl() {
	# Final image only needs static libs for --static-libs linking.
	find /usr/local -type f \( -name '*.so' -o -name '*.so.*' -o -name '*.la' -o -name '*.dll' \) -delete
	find /usr/local -type f -name '*.a' -exec strip --strip-debug {} + 2>/dev/null || true
}

cleanup_image() {
	apt remove --purge -y manpages man-db 2>/dev/null || true
	apt autoremove -y
	apt clean
	rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/share/locale \
		/usr/share/info /var/cache/apt /tmp/* /root/.cache
}
