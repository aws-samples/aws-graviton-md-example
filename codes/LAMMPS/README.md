# README

## 1. LAMMPS Compilation Example

This assumes both the ARM compiler and OpenMPI have already been installed.

Create `compile-lammps.sbatch` as follows:

```bash
#!/bin/bash

#SBATCH --job-name=compile-lammps
#SBATCH --ntasks=64
#SBATCH --output=%x_%j.out

module use /shared/arm/modulefiles
module load libfabric-aws
module load acfl
module load armpl

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

cd ${INSTALLDIR}/lammps/src
make clean-all
make no-all
make yes-most
make yes-molecule
make yes-kspace
make yes-rigid
make yes-asphere
make yes-opt
make yes-openmp
make -j mode=shlib mpi 2>&1 | tee lammps-make-shlib-mpi.out

mkdir -p /shared/lammps/armpl-sve && cp ./lmp_mpi /shared/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl && cp ./liblammps_mpi.so /shared/lammps/armpl-sve/
```

Compile LAMMPS using:

```bash
sbatch compile-lammps.sbatch
```

## 2. LAMMPS Submit Script Example

Create `lj-128.sbatch` for a 128-core job as follows:

```bash
#!/bin/bash

#SBATCH --job-name=lj-128
#SBATCH --ntasks=128
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out

export OMP_NUM_THREADS=1
module use /shared/arm/modulefiles
module load libfabric-aws
module load acfl
module load armpl

LAMMPS_BENCH="/shared/lammps/bench"
cd ${LAMMPS_BENCH}
pwd

NX="32"
NY="32"
NZ="32"
INPUT_FILE = "in.lj"
mpirun -np $SLURM_NTASKS env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/lammps/armpl-sve/ \
    /shared/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl \
    -var x $NX -var y $NY -var z $NZ -in ${INPUT_FILE}
```

Run the LAMMPS job using

```bash
sbatch lj-128.sbatch
```
