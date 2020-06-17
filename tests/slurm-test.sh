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

echo 'Beginning Test Suite'
snap set slurm snap.mode=all
sleep 10
snap services

adduser --disabled-password --gecos "" ubuntu
cd /tmp
slurm.version
slurm.sinfo || slurm.sinfo

echo 'Testing: slurm.srun' && slurm.srun -p debug -n 1 hostname
# echo 'Testing: slurm.srun as ubuntu' && slurm.srun --uid 1000 -N1 -l uname -a # Cannot test due to limitation with Snap: https://forum.snapcraft.io/t/can-a-confined-snap-run-as-a-different-uid-and-or-guid 

echo 'Testing: slurm.scontrol'   && slurm.scontrol show config
echo 'Testing: slurm.squeue'   && slurm.squeue
echo 'Testing: slurm.sshare'   && slurm.sshare
echo 'Testing: slurm.sacct'    && slurm.sacct
echo 'Testing: slurm.sdiag'    && slurm.sdiag

## TODO: Need to test the following commands


# echo 'Testing: slurm.sprio'    && slurm.sprio # Requires priority/multifactor plugin
# echo 'Testing: slurm.sattach'  && slurm.sattach
# slurm.sacctmgr
# slurm.salloc
# slurm.sbatch
# slurm.sbcast
# slurm.scancel
# slurm.scontrol
# slurm.sreport
# slurm.strigger