#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=100
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=run_switch_resource_allocation_sweep_end_node_simplified
#SBATCH -p cpu
#SBATCH --time=48:00:00

module load matlab/r2024a

cd /home/rshiina_umass_edu/R2_v2

matlab -batch "run_switch_resource_allocation_sweep_end_node_simplified"