#!/bin/bash
export PATH=$PATH:/snap/bin

# snap install --dangerous /tmp/slurm_20.02.1_amd64.snap
snap install slurm --channel=edge
snap connect slurm:network-control
snap connect slurm:system-observe
snap connect slurm:hardware-observe

echo 'waiting for 60 seconds'
sleep 10
snap set slurm snap.mode=all
snap services

echo 'Beginning test suite...'

slurm.version

# TODO: The || is needed because the first hit always fails
slurm.sinfo || slurm.sinfo
slurm.sacct
slurm.sdiag
# slurm.sprio
# slurm.sattach
slurm.squeue
slurm.srun -p debug -n 1 hostname
slurm.sshare

##

# slurm.sattach
# slurm.sacctmgr
# slurm.salloc
# slurm.sbatch
# slurm.sbcast
# slurm.scancel
# slurm.scontrol
# slurm.sreport
# slurm.strigger