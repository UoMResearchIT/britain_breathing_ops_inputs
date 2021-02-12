#!/bin/bash --login
#$ -N WRF-%%JOBID%%            
#$ -cwd
#$ -t 1-2
#$ -pe hpc.pe 160
#$ -P hpc-dt-airqual
#$ -hold_jid REAL-%%JOBID%%


module load mpi/intel-17.0/openmpi/3.1.3
module load libs/intel-17.0/netcdf/4.6.2

CWD=%%WRFDIR%%
WPS_DIR=%%WPSDIR%%


WORK_NAMES=( 'EMEP_WRF_50km' 'UK_3km' )
REAL_NAME='EMEP_REAL_50km'

INDEX=$((SGE_TASK_ID-1))

WORK_PATH=${CWD}/${WORK_NAMES[$INDEX]}

cd ${WORK_PATH}

# the EMEP simulation needs more setup, because we are running in a separate directory to REAL
if [[ $SGE_TASK_ID == 1 ]]; then
	ln -s ${CWD}/${REAL_NAME}/wrfbdy_d01 .
	ln -s ${CWD}/${REAL_NAME}/wrfinput_d01 .
	ln -s ${CWD}/${REAL_NAME}/wrffdda_d01 .
	ln -s ${CWD}/${REAL_NAME}/wrflowinp_d01 .
fi

# run the domains with different numbers of processes (due to differing domain sizes)
if [[ $SGE_TASK_ID == 1 ]]; then
	time mpirun -np 153 ./wrf.exe
elif [[ $SGE_TASK_ID == 2 ]]; then
	rm rsl.error.* rsl.out.*
	time mpirun -np 144 ./wrf.exe
fi