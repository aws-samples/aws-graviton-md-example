## This is an example job script of a 1 node job using the Lenard Jones input file. 

#!/bin/bash
#SBATCH --job-name=lj
#SBATCH --partition=queue-1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out

export OMP_NUM_THREADS=1
module use /shared/arm/modulefiles
module load libfabric-aws
module load acfl/23.04.1
module load armpl/23.04.1

# Assuming you have copied the example input data in.lj from the source directory to /fsx/lammpsBM

cd /fsx/lammpsBM
pwd

mpirun -np $SLURM_NTASKS /shared/lammps/armpl-sve/lmp_aarch64_arm_openmpi_armpl -in in.lj