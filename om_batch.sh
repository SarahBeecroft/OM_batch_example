#!/bin/bash -l
#SBATCH --job-name=openmalaria
#SBATCH --nodes=1
#SBATCH --cpus-per-task=128
#SBATCH --ntasks=1
#SBATCH --time=0:15:00
#SBATCH --partition=work
#SBATCH --exclusive
#SBATCH --account=pawsey0012
#SBATCH --mem=0

set -euo pipefail

module load singularity/3.11.4-nompi

# Configuration - UPDATE WITH PATHS TO NECESSARY FILES/INSTALLS
# OM_PATH=
LOGS_DIR=logs
# OUTPUT_DIR=

# Calculate batch size based on node capacity
# For work nodes, estimate that 128 jobs can run concurrently
CHUNK_SIZE=128

#===============================#
# Avoid editing below this line #
#===============================#

# Create log and output dirs- optional 
mkdir -p ${LOGS_DIR}
#mkdir -p ${OUTPUT_DIR}

# Read PARAMS list
mapfile -t PARAMS < $PARAMS_LIST

PARAMS_ARRAY=("${PARAMS[@]}")
TOTAL_PARAMS=${#PARAMS_ARRAY[@]}

echo "Processing ${TOTAL_PARAMS} params in chunks of ${CHUNK_SIZE}..."

# Process params in chunks of 128 at a time
for ((i=0; i<${TOTAL_PARAMS}; i+=CHUNK_SIZE)); do
    CHUNK_NUM=$((i/CHUNK_SIZE + 1))
    echo "Starting chunk ${CHUNK_NUM}..."
    
    # Launch one batch of PARAMs
    for ((j=i; j<i+CHUNK_SIZE && j<${TOTAL_PARAMS}; j++)); do
        PARAM=${PARAMS_ARRAY[$j]}
        echo "Launching param ${PARAM} ($(($j+1))/${TOTAL_PARAMS})" \        
        srun --ntasks=1 \
            --cpus-per-task=1 \
            --mem=2GB \
            --output=${LOGS_DIR}/%j_${PARAM}.log \
            --error=${LOGS_DIR}/%j_${PARAM}.log \
            bash -c "
            echo 'Processing param ${PARAM} on ${SLURM_NODEID}' && \
            sleep 30 && \
            echo 'OM completed for param ${PARAM}' 
            " &
    done
    # Wait for this batch to complete before starting next
    echo "  Waiting for chunk ${CHUNK_NUM} to complete..."
    wait
    echo "  Chunk ${CHUNK_NUM} complete!"
done

# Quick summary
echo "Summary:"
echo "  Total params: ${TOTAL_PARAMS}"
