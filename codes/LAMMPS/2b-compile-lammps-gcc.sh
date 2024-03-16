#!/bin/bash

module use /shared/arm/modulefiles
module load gnu/12.2.0
module load openmpi/4.1.5
module load libfabric-aws/1.17.1
module load armpl/23.04.1

export INSTALLDIR=~/software
export OPENMPI_VERSION=4.1.5
export CC=gcc
export CXX=g++
export FC=gfortran

cd ${INSTALLDIR}/lammps/src/MAKE/MACHINES
target="aarch64_g++_openmpi_armpl"
echo "${target}"
cp Makefile.${target} Makefile.${target}.bak
sed -i 's/CCFLAGS =.*/CCFLAGS = -O3 -march=native -mcpu=native -fopenmp -std=c++11/g' ./Makefile.${target}
sed -i 's/LINKFLAGS =.*/LINKFLAGS = -O -fopenmp -std=c++11/g' ./Makefile.${target}
cd ${INSTALLDIR}/lammps/src/

make clean-all
make no-all
make yes-most
make -j $(nproc) ${target}

mkdir -p /shared/tools/lammps/gcc
cp ${INSTALLDIR}/lammps/src/lmp_${target} /shared/tools/lammps/gcc/
