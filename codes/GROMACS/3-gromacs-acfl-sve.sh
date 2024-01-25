#!/bin/bash
#SBATCH --job-name=Gromacs
#SBATCH --nodes=1
#SBATCH --partition=queue-1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out

export PATH=/shared/tools/openmpi-4.1.5-arml-34/bin:$PATH
export LD_LIBRARY_PATH=/shared/tools/openmpi-4.1.5-arml-34/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=1

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

# Download test case

# Download test case
ls /shared/gromacsBM
if [ $? -eq 1 ]; then
  mkdir /shared/gromacsBM
fi
cd /shared/gromacsBM
wget https://repository.prace-ri.eu/ueabs/GROMACS/2.2/GROMACS_TestCaseA.tar.xz
tar xf GROMACS_TestCaseA.tar.xz
cd GROMACS_TestCaseA

mpirun -np $SLURM_NTASKS /shared/gromacs2022.5-armcl-sve/bin/gmx_mpi mdrun -s ion_channel.tpr -nsteps 10000
