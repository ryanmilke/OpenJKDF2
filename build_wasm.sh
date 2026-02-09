#!/bin/sh

export EMSCRIPTEN_ROOT=$(em-config EMSCRIPTEN_ROOT)

mkdir -p wasm_out
mkdir -p wasm_out/jk1
mkdir -p wasm_out/mots

rm -f wasm_out/openjkdf2.js
rm -f wasm_out/openjkdf2.wasm
rm -f wasm_out/openjkdf2.data
rm -f wasm_out/openjkdf2_data.data
rm -f wasm_out/openjkdf2_data.js
rm -f wasm_out/index.html
rm -rf wasm_out/jk1/resource/shaders
#mkdir -p wasm_out/jk1/resource/shaders
rm -rf wasm_out/mots/resource/shaders
#mkdir -p wasm_out/mots/resource/shaders
#cp resource/shaders/* wasm_out/jk1/resource/shaders
#cp resource/shaders/* wasm_out/mots/resource/shaders

#rm -rf build_emcc
mkdir -p build_emcc && pushd build_emcc
cmake .. --toolchain $(pwd)/../cmake_modules/toolchain_wasm.cmake
cmake .. --toolchain $(pwd)/../cmake_modules/toolchain_wasm.cmake
make -j1 VERBOSE=1
popd

# deploy to neon server
REMOTE_USER="ryanmilke"
REMOTE_HOST="leviathan.milke.net"
REMOTE_DIR="/Users/ryanmilke/Projects/Neon/webui/vendor/openjkdf2/"

scp build_emcc/openjkdf2.js "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/openjkdf2.wasm.js"
scp build_emcc/openjkdf2.wasm "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/openjkdf2.wasm"