#!/bin/bash --login
#$ -N WRF-EU-%%JOBID%%            
#$ -cwd
#$ -pe hpc.pe 160
#$ -P hpc-dt-airqual
#$ -hold_jid REAL-EU-%%JOBID%%


module load mpi/intel-17.0/openmpi/3.1.3
module load libs/intel-17.0/netcdf/4.6.2

CWD=%%WRFDIR%%


WORK_NAME='EMEP_WRF_50km'
REAL_NAME='EMEP_REAL_50km'

INDEX=$((SGE_TASK_ID-1))

WORK_PATH=${CWD}/${WORK_NAME}

cd ${WORK_PATH}

# the EMEP simulation needs more setup, because we are running in a separate directory to REAL
ln -s ${CWD}/${REAL_NAME}/wrfbdy_d01 .
ln -s ${CWD}/${REAL_NAME}/wrfinput_d01 .
ln -s ${CWD}/${REAL_NAME}/wrffdda_d01 .
ln -s ${CWD}/${REAL_NAME}/wrflowinp_d01 .

# run the domains with different numbers of processes (due to differing domain sizes)
rm rsl.error.* rsl.out.*
time mpirun -np 153 ./wrf.exe
