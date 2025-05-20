## 🚀 Building and Pushing Containers

Use the following `make` commands to build and push containers for different SDL versions.

### SDL 1.x

```sh
make build SDL_VERSION=1.2
make push SDL_VERSION=1.2
```

### SDL 2.x

```sh
make build \
  SDL_VERSION=2.32.4 \
  SDL_TTF_VERSION=2.22.0 \
  SDL_IMAGE_VERSION=2.8.2 \
  SDL_MIXER_VERSION=2.8.1 \
  SDL_NET_VERSION=2.2.0

make push \
  SDL_VERSION=2.32.4 \
  SDL_TTF_VERSION=2.22.0 \
  SDL_IMAGE_VERSION=2.8.2 \
  SDL_MIXER_VERSION=2.8.1 \
  SDL_NET_VERSION=2.2.0
```

### SDL 3.x

```sh
make build \
  SDL_VERSION=3.2.14 \
  SDL_TTF_VERSION=3.2.2 \
  SDL_IMAGE_VERSION=3.2.4

make push \
  SDL_VERSION=3.2.14 \
  SDL_TTF_VERSION=3.2.2 \
  SDL_IMAGE_VERSION=3.2.4
```
