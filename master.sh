#!/bin/bash -l

split -l 384 -d ${MYSCRATCH}/input_params.txt batch_

for batch in batch_*; do
    sbatch --export=PARAMS_LIST=$batch om_batch.sh
done
