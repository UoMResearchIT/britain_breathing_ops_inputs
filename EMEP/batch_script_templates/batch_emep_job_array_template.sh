#!/bin/bash --login
#$ -N EMEP-%%JOBID%%            
#$ -cwd
#$ -t 1-2
#$ -pe hpc.pe 128
#$ -P hpc-dt-airqual
#$ -hold_jid_ad WRF-%%JOBID%%
#$ -tc 1


module load libs/gcc/netcdf/4.6.2
module load mpi/gcc/openmpi/3.1.4


CWD=%%EMEPDIR%%
WRF_DIR=%%WRFDIR%%


WRF_NAMES=( 'EMEP_WRF_50km' 'UK_3km' )
MET_NAMES=( 'wrf_meteo/EMEP_grid' 'wrf_meteo/UK_grid' )
WORK_NAMES=( 'EMEP_domain' 'UK_domain' )


INDEX=$((SGE_TASK_ID-1))

WORK_PATH=${CWD}/${WORK_NAMES[$INDEX]}
MET_PATH=${CWD}/${MET_NAMES[$INDEX]}
WRF_PATH=${WRF_DIR}/${WRF_NAMES[$INDEX]}

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
