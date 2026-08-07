#!/bin/bash

refresh_autotools_config() {
	# Old SDL 1.2 releases ship archaic config.guess that rejects aarch64.
	# Prefer Debian's autotools-dev scripts when available.
	local src_guess="/usr/share/misc/config.guess"
	local src_sub="/usr/share/misc/config.sub"
	local guess_dir
	for guess_dir in build-scripts .; do
		if [ -f "${guess_dir}/config.guess" ]; then
			if [ -f "$src_guess" ]; then
				cp "$src_guess" "${guess_dir}/config.guess"
				cp "$src_sub" "${guess_dir}/config.sub"
			else
				curl -sL -o "${guess_dir}/config.guess" "https://git.savannah.gnu.org/cgit/config.git/plain/config.guess"
				curl -sL -o "${guess_dir}/config.sub" "https://git.savannah.gnu.org/cgit/config.git/plain/config.sub"
			fi
			chmod +x "${guess_dir}/config.guess" "${guess_dir}/config.sub"
		fi
	done
}

patch_sdl12_x11() {
	# libX11 >= 1.6 changed _XData32 prototype; release-1.2.15 needs this.
	# Only touch _XData32 — _XRead32 must stay non-const.
	if [ -f src/video/x11/SDL_x11sym.h ]; then
		sed -i '/_XData32/s/register long \*data/register _Xconst long *data/' src/video/x11/SDL_x11sym.h
	fi
}

install_freetype_config_shim() {
	# Debian bookworm dropped freetype-config; SDL_ttf 2.0.x still needs it.
	cat >/usr/local/bin/freetype-config <<'EOF'
#!/bin/sh
prefix=$(pkg-config --variable=prefix freetype2 2>/dev/null || echo /usr)
case "$1" in
	--prefix) echo "$prefix" ;;
	--exec-prefix) echo "$prefix" ;;
	--version|--ftversion) pkg-config --modversion freetype2 ;;
	--cflags) pkg-config --cflags freetype2 ;;
	--libs) pkg-config --libs freetype2 ;;
	*) exit 1 ;;
esac
EOF
	chmod +x /usr/local/bin/freetype-config
}

install_sdl1_source() {
	REPO=$1
	VERSION=$2
	EXTRA_CONFIG=${3:-}
	URL="https://github.com/libsdl-org/${REPO}/archive/refs/tags/release-${VERSION}.tar.gz"
	echo "$URL"
	NPROC=$(nproc)
	WORKDIR=$(mktemp -d --suffix=sdl1)
	cd "${WORKDIR}" &&
		curl -skL "$URL" | tar xvz --strip-components=1 &&
		refresh_autotools_config &&
		if [ "$REPO" = "SDL-1.2" ]; then
			patch_sdl12_x11
			./autogen.sh
			refresh_autotools_config
		elif [ -x ./autogen.sh ]; then
			# Satellite autogen often fails (missing AM_PATH_SDL); keep shipped configure.
			./autogen.sh || true
			refresh_autotools_config
		fi &&
		./configure --prefix=/usr/local --disable-shared --enable-static ${EXTRA_CONFIG} \
			CFLAGS="-Os -g0" CXXFLAGS="-Os -g0" &&
		make --jobs="${NPROC}" && make --jobs="${NPROC}" install &&
		rm -rf "${WORKDIR}"
}

install_sdl1_dependencies() {
	apt update && apt install -y --no-install-recommends \
		libx11-dev libxext-dev libxxf86vm-dev libxrandr-dev libxrender-dev \
		libxi-dev libxss-dev libasound2-dev \
		libfreetype6-dev libpng-dev libjpeg-dev zlib1g-dev \
		libogg-dev libvorbis-dev libflac-dev libmikmod-dev
	install_freetype_config_shim
}

install_sdl1() {
	install_sdl1_dependencies
	export PATH="/usr/local/bin:${PATH}"
	export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
	install_sdl1_source SDL-1.2 "${SDL_VERSION}"
	# SDL_ttf for SDL1 is the historic 2.0.x line.
	install_sdl1_source SDL_ttf "${SDL_TTF_VERSION}"
	install_sdl1_source SDL_image "${SDL_IMAGE_VERSION}" "--enable-png --enable-jpg --disable-tif"
	install_sdl1_source SDL_mixer "${SDL_MIXER_VERSION}"
	install_sdl1_source SDL_net "${SDL_NET_VERSION}"
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
		pkg-config autoconf automake libtool autotools-dev \
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
					libx11-dev libxext-dev libxxf86vm-dev libxrandr-dev libxrender-dev \
					libxi-dev libxss-dev libasound2-dev \
					libfreetype6-dev libpng-dev libjpeg-dev \
					libogg-dev libvorbis-dev libflac-dev libmikmod-dev ;; \
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
