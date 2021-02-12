#!/bin/bash --login
#$ -N EMEP-UK-%%JOBID%%            
#$ -cwd
#$ -pe hpc.pe 128
#$ -P hpc-dt-airqual
#$ -hold_jid WRF-UK-%%JOBID%%,EMEP-EU-%%JOBID%%


module load libs/gcc/netcdf/4.6.2
module load mpi/gcc/openmpi/3.1.4


CWD=%%EMEPDIR%%
WRF_DIR=%%WRFDIR%%


WRF_NAME='UK_3km'
MET_NAME='wrf_meteo/UK_grid'
WORK_NAME='UK_domain'


WORK_PATH=${CWD}/${WORK_NAME}
MET_PATH=${CWD}/${MET_NAME}
WRF_PATH=${WRF_DIR}/${WRF_NAME}

### EMEP executable
EMEP_EXEC=%%EMEPEXEC%%


### function for linking WRF output files in an EMEP friendly manner
link_met_data () {
	file_list=$(ls -1 $1/wrfout*)

	for FILE in ${file_list[@]};
	do
		parts=(${FILE//// })              # split FILE string on the / delimiter
		filename=${parts[${#parts[@]}-1]} # select the last value, which is the filename
		fileparts=(${filename//:/ })      # split the filename string on the : delimiter
		LOCAL_FILE=${fileparts[0]}        # select the first value as our local filename
		ln -s $FILE $LOCAL_FILE  
	done
}


### operational code

# create the met file links
cd ${MET_PATH}
link_met_data ${WRF_PATH}

# run EMEP
cd ${WORK_PATH}
mpiexec --mca -np 128 ${EMEP_EXEC}
