#!/bin/bash
#SBATCH --job-name=CPS_SOM
#SBATCH --time=24:00:00 # hh:mm:ss

#SBATCH --ntasks=1 
#SBATCH --gres="gpu:2"
#SBATCH --mem-per-cpu=100000 # megabytes 
#SBATCH --mail-user=adzheng@scu.edu
#SBATCH --mail-type=ALL
#SBATCH --partition=gpu
#SBATCH --comment=MINWAGE


module load R
srun Rscript REMOTE_SOM.R

