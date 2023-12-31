#!/bin/bash

# assuming you are installing LAMMPS under /shared

module use /shared/arm/modulefiles
module load libfabric-aws
module load acfl
module load armpl

INSTALL_FOLDER="/shared"
cd ${INSTALL_FOLDER}
if [ ! -d "lammps" ]; then
    git clone -b stable https://github.com/lammps/lammps.git lammps
fi
cd lammps
git checkout stable
cd src/MAKE/MACHINES
sed -i 's/CCFLAGS =      -O3 -mcpu=native/CCFLAGS =       -O3 -march=armv8-a+sve/g'  Makefile.aarch64_arm_openmpi_armpl

cd ../..

# assuming you are using c7g.4xlarge to compile

make clean-all 2>&1 | tee lammps-make-clean-all.out
make no-all 2>&1 | tee lammps-make-no-all.out
make yes-most 2>&1 | tee lammps-make-yes-most.out
make -j 16 mode=shlib mpi 2>&1 | tee lammps-make-mode-shlib-mpi.out

mkdir -p /shared/lammps/armpl-sve && cp ./lmp_mpi /shared/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl && cp ./liblammps_mpi.so /shared/lammps/armpl-sve/
