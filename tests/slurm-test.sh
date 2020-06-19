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

echo 'Setting Snap Mode...'
snap set slurm snap.mode=all
sleep 10
snap services

adduser --disabled-password --gecos "" ubuntu
cd /tmp
slurm.version
slurm.sinfo || slurm.sinfo

echo 'Beginning manual aliasing...'

snap alias slurm.srun srun
snap alias slurm.scontrol scontrol
snap alias slurm.squeue squeue
snap alias slurm.sshare sshare
snap alias slurm.sacct sacct
snap alias slurm.sdiag sdiag

snap set slurm snap.mode=none
snap set slurm snap.mode=all
sleep 5

echo 'Beginning Test Suite'

echo 'Testing: srun'           && srun -p debug -n 1 hostname
echo 'Testing: srun as ubuntu' && srun --uid 1000 -N1 -l uname -a

echo 'Testing: sacctmgr'       && sacctmgr show problem
echo 'Testing: scontrol'       && scontrol show config
echo 'Testing: squeue'         && slurm.squeue --long
echo 'Testing: sshare'         && sshare -al
echo 'Testing: sacct'          && slurm.sacct -al
echo 'Testing: sdiag'          && sdiag -a
echo 'Testing: salloc'          && salloc --usage
echo 'Testing: sbatch'          && sbatch --usage
echo 'Testing: sbcast'          && sbcast -V
echo 'Testing: scancel'         && scancel -fA 1
echo 'Testing: scontrol'        && scontrol all
echo 'Testing: sreport'         && sreport verbose
echo 'Testing: strigger'        && strigger --get
