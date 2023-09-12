#!/bin/bash

function install_emsdk() {
	cd /opt &&
		# Get the emsdk repo
		git clone https://github.com/emscripten-core/emsdk.git &&
		# Enter that directory
		cd emsdk &&
		# Fetch the latest version of the emsdk (not needed the first time you clone)
		git pull &&
		# Download and install the latest SDK tools.
		./emsdk install latest &&
		# Make the "latest" SDK "active" for the current user. (writes .emscripten file)
		./emsdk activate latest
	# Activate PATH and other environment variables in the current terminal
	echo "source /opt/emsdk/emsdk_env.sh" >>~/.profile
}

install_sdl1() {
	apt install -y libsdl1.2-dev libsdl-ttf2.0-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-net1.2-dev
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
