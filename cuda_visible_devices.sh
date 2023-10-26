#!/bin/bash

# srun -N1 -n1 -t1 -pnvgpu nvidia-smi topo -m
#       GPU0    GPU1    GPU2    GPU3    CPU Affinity    NUMA Affinity
# GPU0     X     NV4    NV4    NV4    48-63,112-127    3
# GPU1    NV4     X     NV4    NV4    32-47,96-111    2
# GPU2    NV4    NV4     X     NV4    16-31,80-95    1
# GPU3    NV4    NV4    NV4     X     0-15,64-79    0

GPUSID=(3 2 1 0)
let lrank=$SLURM_LOCALID%4
export CUDA_VISIBLE_DEVICES=${GPUSID[lrank]}
exec -- $*
