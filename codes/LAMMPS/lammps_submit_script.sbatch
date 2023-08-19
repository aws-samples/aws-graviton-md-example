#!/bin/bash

#SBATCH --job-name=myjobname
#SBATCH --ntasks=256
#SBATCH --output=%x_%j.out

mpirun -np 256 lmp_mpi -in my-input-file
