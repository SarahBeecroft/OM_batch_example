# OM_batch_example
Example for running batches of tasks in with per-node load balancing in SLURM for the OpenMalaria use case

1. Make input_params.txt- one param set per line
2. Decide how many multiples of 128 you want to process per batch and set that in master.sh (the -l 128 flag)
3. Fix up paths/variables in om_batch.sh
4. Put in your actual code where the sleep command is
5. To launch, run `bash master.sh` and this will launch as many slurm jobs as needed to run all your samples. If you have 1000 samples at with batch size 384, it'll launch 3 slurm jobs.
6. Success
