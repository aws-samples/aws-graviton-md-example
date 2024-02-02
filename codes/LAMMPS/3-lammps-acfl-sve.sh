#!/bin/bash
#SBATCH --job-name=lj
#SBATCH --partition=queue-1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out

## This is an example job script of a 1 node job using the Lenard Jones input file. 

export PATH=/shared/tools/openmpi-4.1.5-arml-34/bin:$PATH
export LD_LIBRARY_PATH=/shared/tools/openmpi-4.1.5-arml-34/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=1

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

LAMMPS_BENCH="/shared/lammps/bench"
cd ${LAMMPS_BENCH}

mpirun -np $SLURM_NTASKS env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/lammps/armpl-sve/ /shared/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl -in in.lj
