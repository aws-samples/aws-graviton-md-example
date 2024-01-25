#!/bin/bash

mkdir ~/software && cd ~/software
wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4.tar.gz
tar zxvf cmake-3.26.4.tar.gz
cd cmake-3.26.4/
./configure --prefix=/shared/tools/cmake-3.26.4-arm64
make -j $(nprocs)
make install
