##
# Purpose: To install the latest stable version of CMake under /home/ec2-user
# Software toolchain: GNU compiler
# July, 2023 
# JEN-CHANG CHEN; jamchn@amazon.com
## Download cmake 3.26.4
## Assume source code stored in folder ~/software 
cd ~/software
wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4.tar.gz
tar zxvf cmake-3.26.4.tar.gz
cd cmake-3.26.4/
./configure --prefix=/home/ec2-user/cmake-3.26.4-arm64
make -j 16
make install
# Env: vi ~/.bashrc and add the following lines into .bashrc
export PATH=/home/ec2-user/cmake-3.26.4-arm64/bin:$PATH
