#!/bin/bash
export PATH=$PATH:/snap/bin

snap install --dangerous /tmp/slurm_20.02.1_amd64.snap
snap connect slurm:network-control
snap connect slurm:system-observe
snap connect slurm:hardware-observe

snap set slurm snap.mode=all
snap services

# slurm.sacct
# slurm.sacctmgr
# slurm.salloc
# slurm.sattach
# slurm.sbatch
# slurm.sbcast
# slurm.scancel
# slurm.scontrol
# slurm.sdiag
# slurm.sinfo
# slurm.sprio
# slurm.sattach
# slurm.squeue
# slurm.sreport
# slurm.srun
slurm.sshare
# slurm.strigger