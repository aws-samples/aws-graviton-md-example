#!/bin/bash

# assuming you are installing LAMMPS under /shared

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

export PATH=/shared/tools/openmpi-4.1.5-arml-34/bin:$PATH
export LD_LIBRARY_PATH=/shared/tools/openmpi-4.1.5-arml-34/lib:$LD_LIBRARY_PATH
export INSTALLDIR="/shared"
export OPENMPI_VERSION=4.1.5
export CC=armclang
export CXX=armclang++
export FC=armflang
export CFLAGS="-mcpu=neoverse-512tvb"

cd ${INSTALLDIR}/lammps/src/MAKE/MACHINES
target="aarch64_arm_openmpi_armpl"
echo "${target}"
sed -i 's/CCFLAGS =\t-O3 -mcpu=native/CCFLAGS =       -O3 -march=armv8-a+sve -fopenmp -mcpu=neoverse-v1 --param=aarch64-autovec-preference=1/g' ./Makefile.${target}
sed -i 's/LINKFLAGS =\t-g -O/LINKFLAGS =     -g -O -fopenmp/g' ./Makefile.${target}
cd ../..

make clean-all
make no-all
make yes-most
make yes-molecule
make yes-kspace
make yes-rigid
make yes-asphere
make yes-opt
make yes-openmp
make -j $(nproc) mode=shlib mpi 2>&1 | tee lammps-make-mode-shlib-mpi.out

mkdir -p /shared/lammps/armpl-sve && cp ./lmp_mpi /shared/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl && cp ./liblammps_mpi.so /shared/lammps/armpl-sve/
