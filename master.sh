#!/bin/bash -l

split -l 384 -d ${MYSCRATCH}/DeepMEI/samples.txt batch_

for batch in batch_*; do
    sbatch --export=SAMPLE_LIST=$batch deepmei_batch.sh
done
