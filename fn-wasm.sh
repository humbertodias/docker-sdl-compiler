#!/bin/bash

EMSDK_ROOT="${EMSDK:-/emsdk}"

setup_emsdk() {
	ln -sf "${EMSDK_ROOT}" /opt/emsdk
	if ! grep -q 'emsdk_env.sh' ~/.bashrc 2>/dev/null; then
		echo "source ${EMSDK_ROOT}/emsdk_env.sh" >>~/.bashrc
	fi
}

cleanup_image() {
	rm -rf "${EMSDK_ROOT}/downloads" \
		"${EMSDK_ROOT}/upstream/emscripten/test" \
		"${EMSDK_ROOT}/upstream/emscripten/docs"

	apt remove --purge -y manpages man-db 2>/dev/null || true
	apt autoremove -y
	apt clean
	rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/share/locale /tmp/*
}
