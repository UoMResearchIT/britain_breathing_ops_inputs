#!/bin/bash --login
#$ -N WRF-UK-%%JOBID%%            
#$ -cwd
#$ -pe hpc.pe 160
#$ -P hpc-dt-airqual
#$ -hold_jid REAL-UK-%%JOBID%%


module load mpi/intel-17.0/openmpi/3.1.3
module load libs/intel-17.0/netcdf/4.6.2

CWD=%%WRFDIR%%

WORK_NAME='UK_3km'


WORK_PATH=${CWD}/${WORK_NAME}

cd ${WORK_PATH}


# run the domains with different numbers of processes (due to differing domain sizes)
rm rsl.error.* rsl.out.*
time mpirun -np 144 ./wrf.exe
