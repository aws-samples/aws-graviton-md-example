##
# Purpose: To build and install the OpenMPI 4.1.5 linked with ARM compiler for Linux under /home/ec2-user
# Software toolchain: OpenMPI 4.1.5 and ARM compiler for Linux 23.04
# July, 2023 
# JEN-CHANG CHEN; jamchn@amazon.com
#
# Prerequisite
# ARM compiler for Linux 23.04 has been installed and loaded
module load libfabric-aws
module load acfl/23.04.1
module load armpl/23.04.1 

#!/bin/bash
## Create a folder under /home/ec2-user
mkdir ~/software
cd ~/software
## download the source code of OpenMPI
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz
tar zxvf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5
## configure (assuming you install openmpi in your /home directory)
./configure --prefix=/home/ec2-user/openmpi-4.1.5-arml-34 CC=armclang CXX=armclang++ FC=armflang --enable-mpi-cxx --enable-mpi-fortran=all --without-verbs --enable-builtin-atomics --with-libfabric=/opt/amazon/efa  --with-libfabric-libdir=/opt/amazon/efa/lib64
## make for c7g.4xl
make -j 16
## make install
make install
## Setup .bashrc environment into your .bashrc
## OpenMPI with ARM compiler, please copy the following two lines into your .bashrc
export PATH=/home/ec2-user/openmpi-4.1.5-arml-34/bin:$PATH
export LD_LIBRARY_PATH=/home/ec2-user/openmpi-4.1.5-arml-34/lib:$LD_LIBRARY_PATH