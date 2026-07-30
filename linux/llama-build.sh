#!/bin/bash
cd ~/dev/llama.cpp
rm -rf build
cmake . -B build \
    -DBUILD_SHARED_LIBS=OFF \
    -DGGML_CUDA=ON \
    -DCUDAToolkit_ROOT=/opt/cuda \
    -DCMAKE_CUDA_COMPILER=/opt/cuda/bin/nvcc
cmake --build build --config Release \
    -j --clean-first --target llama-server
cp build/bin/llama-* .
