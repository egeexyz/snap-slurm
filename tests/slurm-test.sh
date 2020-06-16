#!/bin/bash

set -e

DISTRO=$(lsb_release -d)
SNAP_PATH="/tmp/slurm.snap"


if [[ "${DISTRO}" == *"Ubuntu"* ]]; then
  export PATH=$PATH:/snap/bin
else
  export PATH=$PATH:/var/lib/snapd/snap/bin
  dnf install -y epel-release
  dnf upgrade -y
  dnf install -y snapd
  systemctl enable --now snapd.socket
  ln -s /var/lib/snapd/snap /snap
fi

snap install --dangerous ${SNAP_PATH} || snap install --dangerous --classic ${SNAP_PATH}

snap connect slurm:network-control  || echo 'Plug not supported, passing...'
snap connect slurm:system-observe   || echo 'Plug not supported, passing...'
snap connect slurm:hardware-observe || echo 'Plug not supported, passing...'

echo 'Beginning Tests...'
systemctl restart snap.slurm.slurmctld
sleep 10
snap set slurm snap.mode=all
snap services

slurm.version

# TODO: Enable tests below

# TODO: The || is needed because the first hit always fails
slurm.sinfo || slurm.sinfo
slurm.sacct
slurm.sdiag
slurm.sprio
slurm.sattach
slurm.squeue
slurm.srun -p debug -n 1 hostname
# slurm.srun --uid 1000 -N1 -l hostname
scontrol show config
slurm.sshare

## TODO: Need to test the following commands

# slurm.sattach
# slurm.sacctmgr
# slurm.salloc
# slurm.sbatch
# slurm.sbcast
# slurm.scancel
# slurm.scontrol
# slurm.sreport
# slurm.strigger