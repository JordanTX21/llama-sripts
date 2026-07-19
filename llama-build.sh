#!/bin/bash
cd ~/dev
rm -rf llama.cpp/build
cmake llama.cpp -B llama.cpp/build \
    -DBUILD_SHARED_LIBS=OFF \
    -DGGML_CUDA=ON \
    -DCUDAToolkit_ROOT=/opt/cuda \
    -DCMAKE_CUDA_COMPILER=/opt/cuda/bin/nvcc
cmake --build llama.cpp/build --config Release \
    -j 8 --clean-first --target llama-server llama-gguf-split
cp llama.cpp/build/bin/llama-* llama.cpp
