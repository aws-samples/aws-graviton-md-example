#!/bin/bash

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

export PATH=/shared/tools/openmpi-4.1.5-arml/bin:$PATH
export LD_LIBRARY_PATH=/shared/tools/openmpi-4.1.5-arml/lib:$LD_LIBRARY_PATH
export INSTALLDIR=~/software
export OPENMPI_VERSION=4.1.5
export CC=armclang
export CXX=armclang++
export FC=armflang

cd ${INSTALLDIR}/lammps/src/MAKE/MACHINES
target="aarch64_arm_openmpi_armpl"
echo "${target}"
cp Makefile.${target} Makefile.${target}.bak
sed -i 's/CCFLAGS =.*/CCFLAGS = -O3 -march=armv8-a+sve/g' ./Makefile.${target}
cd ../..

make clean-all
make no-all
make yes-most
make -j $(nproc) ${target}

mkdir -p /shared/tools/lammps/armpl-sve
cp ${INSTALLDIR}/lammps/src/lmp_${target} /shared/tools/lammps/armpl-sve/
