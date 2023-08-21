##
# Purpose: To submit your job in AWS ParallelCluster environment using SLURM scheduler
# Software toolchain: OpenMPI 4.1.5 and ARM compiler for Linux 23.04
# July, 2023 
# JEN-CHANG CHEN; jamchn@amazon.com

#!/bin/bash
#SBATCH --job-name=Gromacs
#SBATCH --nodes=1
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

# You need to cd to the directory your input file (ion_channel.tpr) is in.
# In this example we assume that you have the input file on /fsx/gromacsBM

cd /fsx/gromacsBM
mpirun -np $SLURM_NTASKS /home/ec2-user/gromacs2022.5-armcl-armcom/bin/gmx_mpi mdrun -s ion_channel.tpr -nsteps 10000
