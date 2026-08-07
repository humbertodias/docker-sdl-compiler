MAIN := main

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
		echo "Use hldtux/sdl-compiler-native:1.2.15|2.32.10|3.4.14 matching the sample." >&2; \
		exit 1; \
	fi

sdl1:
	g++ sdl1/main.cpp -o sdl1/$(MAIN) -g `sdl-config --cflags --static-libs`

sdl2:
	g++ sdl2/main.cpp -o sdl2/$(MAIN) -g `sdl2-config --cflags --static-libs`

sdl3:
	g++ sdl3/main.cpp -o sdl3/$(MAIN) -g `pkg-config sdl3 --cflags --libs`

wasm:
	cd emsdk && \
	emcc main-sdl1.cpp -o sdl1.html -s USE_SDL=1 -s WASM=1 && \
	emcc main-sdl2.cpp -o sdl2.html -s USE_SDL=2 -s WASM=1 && \
	emcc main-sdl3.cpp -o sdl3.html -s USE_SDL=3 -s WASM=1

build/native: native
build/wasm: wasm

clean:
	rm -f sdl1/$(MAIN) sdl2/$(MAIN) sdl3/$(MAIN)
	rm -f emsdk/sdl1.* emsdk/sdl2.* emsdk/sdl3.*
