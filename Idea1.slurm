#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=60
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=Idea1
#SBATCH -p cpu
#SBATCH --time=30:00:00

module load matlab/r2024a

cd /home/rshiina_umass_edu/matlab_simulation_switch

matlab -batch "Idea1"