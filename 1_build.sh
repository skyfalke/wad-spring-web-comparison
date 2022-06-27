#!/bin/bash
set -e

podman machine start

cd wad-pong && ./build.sh
cd ..
cd wad-mvc && ./build.sh
cd ..
cd wad-webflux-reactor && ./build.sh
cd ..
cd wad-webflux-reactor-coroutines && ./build.sh
cd ..
cd wad-webflux-coroutines && ./build.sh
cd ..
cd wad-prometheus && ./build.sh
cd ..

podman machine stop