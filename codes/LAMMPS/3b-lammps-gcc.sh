#!/bin/bash
#SBATCH --job-name=lj
#SBATCH --nodes=4
#SBATCH --partition=queue-1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out

## This is an example job script of a 4 node job using the Lenard Jones input file. 

module use /shared/arm/modulefiles
module load gnu/12.2.0
module load openmpi/4.1.5
module load libfabric-aws/1.17.1
module load armpl/23.04.1

export OMPI_MCA_mtl_base_verbose=1
export NX=32
export NY=32
export NZ=32

export LAMMPS_EXE="/shared/tools/lammps/armpl-sve/lmp_aarch64_g++_openmpi_armpl_O3_mpcu_march_native_omp"
MPIRUN=$(which mpirun)

# Download test case
curl -o in.lj "https://www.lammps.org/inputs/in.lj.txt"

# 256 cores, 256 MPI processes (64 per node), 1 OpenMP thread
# export OMP_NUM_THREADS=1
# $MPIRUN -np 256 --map-by ppr:64:node $LAMMPS_EXE -sf omp -var x $NX -var y $NY -var z $NZ -in in.lj

# 256 cores, 128 MPI processes (32 per node), 2 OpenMP threads
export OMP_NUM_THREADS=2
$MPIRUN -np 128 --map-by ppr:32:node $LAMMPS_EXE -sf omp -var x $NX -var y $NY -var z $NZ -in in.lj

# 256 cores, 64 MPI processes (16 per node), 4 OpenMP threads
# export OMP_NUM_THREADS=4
# $MPIRUN -np 64 --map-by ppr:16:node $LAMMPS_EXE -sf omp -var x $NX -var y $NY -var z $NZ -in in.lj
