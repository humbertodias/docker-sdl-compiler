MAIN := main
CC := g++

.PHONY: all native wasm clean sdl1 sdl2 sdl3 build/native build/wasm

# Each native image ships only one SDL major version.
# `make` / `make native` builds whichever is available.
all: native

native:
	@built=0; \
	if command -v sdl-config >/dev/null 2>&1 || pkg-config --exists sdl 2>/dev/null; then \
		$(MAKE) --no-print-directory sdl1 && built=1; \
	fi; \
	if command -v sdl2-config >/dev/null 2>&1 || pkg-config --exists sdl2 2>/dev/null; then \
		$(MAKE) --no-print-directory sdl2 && built=1; \
	fi; \
	if pkg-config --exists sdl3 2>/dev/null; then \
		$(MAKE) --no-print-directory sdl3 && built=1; \
	fi; \
	if [ "$$built" -eq 0 ]; then \
		echo "No SDL toolkit found in this image." >&2; \
		echo "Use hldtux/sdl-compiler-native:1.2.15|2.32.10|3.4.16 matching the sample." >&2; \
		exit 1; \
	fi

sdl1:
	$(CC) -I. sdl1/main.cpp -o sdl1/$(MAIN) -g `pkg-config --static --cflags --libs sdl`

sdl2:
	$(CC) -I. sdl2/main.cpp -o sdl2/$(MAIN) -g `pkg-config --static --cflags --libs sdl2`

sdl3:
	$(CC) -I. sdl3/main.cpp -o sdl3/$(MAIN) -g `pkg-config --static --cflags --libs sdl3`

wasm:
	emcc -I. emsdk/main-sdl1.cpp -o emsdk/sdl1.html -s WASM=1 \
	    -s USE_SDL=1 && \
	emcc -I. emsdk/main-sdl2.cpp -o emsdk/sdl2.html -s WASM=1 \
		-s USE_SDL=2 -s USE_SDL_TTF=2 -s USE_SDL_IMAGE=2 -s USE_SDL_MIXER=2 -s USE_SDL_NET=2 && \
	emcc -I. emsdk/main-sdl3.cpp -o emsdk/sdl3.html -s WASM=1 \
		-s USE_SDL=3 -s USE_SDL_TTF=3

build/native: native
build/wasm: wasm

clean:
	rm -f sdl1/$(MAIN) sdl2/$(MAIN) sdl3/$(MAIN)
	rm -f emsdk/sdl1.* emsdk/sdl2.* emsdk/sdl3.*
