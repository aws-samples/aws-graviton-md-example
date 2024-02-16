#!/bin/bash
#SBATCH --job-name=lj
#SBATCH --nodes=4
#SBATCH --partition=queue-1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out

## This is an example job script of a 1 node job using the Lenard Jones input file. 

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

export PATH=/shared/tools/openmpi-4.1.5-arml/bin:$PATH
export LD_LIBRARY_PATH=/shared/tools/openmpi-4.1.5-arml/lib:$LD_LIBRARY_PATH

export OMP_NUM_THREADS=1
export OMPI_MCA_mtl_base_verbose=1
export NX=32
export NY=32
export NZ=32

MPIRUN="/shared/tools/openmpi-4.1.5-arml/bin/mpirun"
LAMMPS_EXE="/shared/tools/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl"
N="256"

# Download test case
mkdir -p /shared/lammpsLJ

cd /shared/lammpsLJ
curl -o in.lj "https://www.lammps.org/inputs/in.lj.txt"

$MPIRUN -np $N $LAMMPS_EXE -var x $NX -var y $NY -var z $NZ -in in.lj
