#!/bin/bash
#PBS -P r78 
#PBS -q megamem 
#PBS -N WITv2
#PBS -l walltime=24:00:00
#PBS -l mem=6TB
#PBS -l jobfs=1600GB
#PBS -l ncpus=64
#PBS -l wd
#PBS -M bex.dunn@ga.gov.au
#PBS -m abe


#NNODES=2
NNODES=$(cat $PBS_NODEFILE | uniq | wc -l)
NCPUS=32
NCHUNKS=64
JOBDIR=$PWD

for i in $(seq 0 $(($NNODES-1))); do
    if [ $i -lt 1 ]
    then
        PARAMF="{1..32},$NCHUNKS"
    else
        PARAMF="{33..64},$NCHUNKS"
    fi
    pbsdsh -n $(( $NCPUS*$i )) -- \
    bash -l -c "\
    module use /g/data/v10/public/modules/modulefiles/;\
    module load dea;\
    module load parallel;\
    echo $i:\
    cd $JOBDIR;\
    parallel --delay 5 --retries 3 --load 100%  --colsep ',' python /g/data/r78/rjd547/jupyter_notebooks/dea-notebooks/05_Temporal_analysis/raijinify_wetland_working/WIT_v2/Wetlands_Insight_Tool_raijin_v2.py ::: $PARAMF"&
done;
wait;