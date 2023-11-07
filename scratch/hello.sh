#!/bin/bash
#SBATCH --no-requeue
#SBATCH --get-user-env
#SBATCH --mem=1
#SBATCH --partition=jobs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0:02:00

OUT=hello.out
echo "Hello, world!" > $OUT

srun id >> $OUT
srun hostname >> $OUT

