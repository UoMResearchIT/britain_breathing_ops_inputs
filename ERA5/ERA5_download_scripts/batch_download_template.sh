#!/bin/bash --login
#$ -N ERA5-%%JOBID%%            
#$ -cwd

source ~/bin/conda_activate.sh 
conda activate cds-api


python download.py 2>&1 | tee log_download.txt
