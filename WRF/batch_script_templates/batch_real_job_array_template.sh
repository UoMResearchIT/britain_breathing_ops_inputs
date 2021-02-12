#!/bin/bash --login
#$ -N REAL-%%JOBID%%            
#$ -cwd
#$ -t 1-2
#$ -pe smp.pe 6
#$ -hold_jid WPS-%%JOBID%%


module load mpi/intel-17.0/openmpi/3.1.3
module load libs/intel-17.0/netcdf/4.6.2

CWD=%%WRFDIR%%
WPS_DIR=%%WPSDIR%%


WPS_NAMES=( 'WPS_METGRID_50km' 'WPS_METGRID_3km' )
WORK_NAMES=( 'EMEP_REAL_50km' 'UK_3km' )

INDEX=$((SGE_TASK_ID-1))

WORK_PATH=${CWD}/${WORK_NAMES[$INDEX]}
WPS_PATH=${WPS_DIR}/${WPS_NAMES[$INDEX]}

cd ${WORK_PATH}

ln -s ${WPS_PATH}/met_em.* .


time mpirun -np 6 ./real.exe
