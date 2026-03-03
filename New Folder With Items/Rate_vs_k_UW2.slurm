#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=120
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=Rate_vs_k_UW2
#SBATCH -p cpu
#SBATCH --time=30:00:00

module load matlab/r2024a

cd /home/rshiina_umass_edu/matlab_simulation

matlab -batch "Rate_vs_k_UW2"