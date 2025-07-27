MAIN := main

build/native:
	g++ sdl1/main.cpp -o sdl1/$(MAIN) -g `pkg-config sdl --cflags --libs`
	g++ sdl2/main.cpp -o sdl2/$(MAIN) -g `pkg-config sdl2 --cflags --libs`
	g++ sdl3/main.cpp -o sdl3/$(MAIN) -g `pkg-config sdl3 --cflags --libs`

build/wasm:
	cd emsdk && \
	emcc main-sdl1.cpp -o sdl1.html -s USE_SDL=1 -s WASM=1 && \
	emcc main-sdl2.cpp -o sdl2.html -s USE_SDL=2 -s WASM=1 && \
	emcc main-sdl3.cpp -o sdl3.html -s USE_SDL=3 -s WASM=1

clean:
	rm -f sdl1/$(MAIN) sdl2/$(MAIN) sdl3/$(MAIN)
	rm -f emsdk/sdl1.* emsdk/sdl2.* emsdk/sdl3.*