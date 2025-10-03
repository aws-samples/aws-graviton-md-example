#!/bin/bash

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

## Create a folder under /home/ec2-user
mkdir ~/software && cd ~/software

## download the source code of OpenMPI
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz
tar zxvf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5

## configure and make openmpi-4.1.5
mkdir build-acfl && cd build-acfl
../configure --prefix=/shared/tools/openmpi-4.1.5-arml CC=armclang CXX=armclang++ FC=armflang --enable-mpi-cxx --enable-mpi-fortran=all --without-verbs --enable-builtin-atomics --with-libfabric=/opt/amazon/efa  --with-libfabric-libdir=/opt/amazon/efa/lib64
make -j $(nproc) && make install
