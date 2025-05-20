#!/bin/bash

function install_emsdk() {
  VERSION=$1
  mkdir -p /opt && cd /opt
  curl -kL -o emsdk.tar.gz https://github.com/emscripten-core/emsdk/archive/refs/tags/${VERSION}.tar.gz
  tar -xzf emsdk.tar.gz && rm emsdk.tar.gz
  mv emsdk-${VERSION} emsdk && cd emsdk
  ./emsdk install ${VERSION}
  ./emsdk activate ${VERSION}
  echo "source /opt/emsdk/emsdk_env.sh" >> ~/.bashrc
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
    cmake --build . --config Release --parallel
    cmake --install . --config Release
    rm -rf ${WORKDIR}
}