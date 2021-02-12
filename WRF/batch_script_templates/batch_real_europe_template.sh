#!/bin/bash --login
#$ -N REAL-EU-%%JOBID%%            
#$ -cwd
#$ -pe smp.pe 6
#$ -hold_jid WPS-%%JOBID%%


module load mpi/intel-17.0/openmpi/3.1.3
module load libs/intel-17.0/netcdf/4.6.2

CWD=%%WRFDIR%%
WPS_DIR=%%WPSDIR%%


WPS_NAME='WPS_METGRID_50km'
WORK_NAME='EMEP_REAL_50km'


WORK_PATH=${CWD}/${WORK_NAME}
WPS_PATH=${WPS_DIR}/${WPS_NAME}

cd ${WORK_PATH}

ln -s ${WPS_PATH}/met_em.* .


time mpirun -np 6 ./real.exe
