#!/bin/bash

set -e

DISTRO=$(uname -r)
SNAP_PATH="/tmp/slurm.snap"

if [[ "${DISTRO}" == *".el8_"* ]]; then
  export PATH=$PATH:/var/lib/snapd/snap/bin
  dnf install -y epel-release
  dnf upgrade -y
  dnf install -y snapd
  systemctl enable --now snapd.socket
  ln -s /var/lib/snapd/snap /snap
else
  export PATH=$PATH:/snap/bin
fi

snap install --dangerous --classic ${SNAP_PATH}


echo '!!SETTING INITIAL SNAP MODE!!'
snap set slurm snap.mode=all
sleep 10

useradd -m -s /bin/bash slurmuser

cd /tmp
slurm.version
snap services
slurm.sinfo || slurm.sinfo

echo '!!MANUAL ALIASING!!'

snap alias slurm.srun srun
snap alias slurm.scontrol scontrol
snap alias slurm.squeue squeue
snap alias slurm.sshare sshare
snap alias slurm.sacct sacct
snap alias slurm.sdiag sdiag
snap alias slurm.sacctmgr sacctmgr
snap alias slurm.salloc salloc
snap alias slurm.sbatch sbatch
snap alias slurm.sbcast sbcast
snap alias slurm.scancel scancel
snap alias slurm.scontrol scontrol
snap alias slurm.sreport sreport
snap alias slurm.strigger strigger

snap alias slurm.munge munge
snap alias slurm.unmunge unmunge
snap alias slurm.remunge remunge
snap alias slurm.mungekey mungekey

echo '!!TESTING SNAP MODES!!'

snap set slurm snap.mode=none
snap set slurm snap.mode=slurmd
snap set slurm snap.mode=slurmdbd
snap set slurm snap.mode=slurmrestd
snap set slurm snap.mode=slurmdbd+mysql
snap set slurm snap.mode=all
sleep 1

echo '!!EXECUTING USER COMMANDS!!'

echo 'Testing: srun'            && srun -p debug -n 1 hostname
echo 'Testing: srun as slurmuser'  && srun --uid 1000 -N1 -l uname -a

echo 'Testing: sacctmgr'        && sacctmgr show problem
echo 'Testing: scontrol'        && scontrol show config
echo 'Testing: squeue'          && slurm.squeue --long
echo 'Testing: sshare'          && sshare -al
echo 'Testing: sacct'           && slurm.sacct -al
echo 'Testing: sdiag'           && sdiag -a
echo 'Testing: salloc'          && salloc --usage
echo 'Testing: sbatch'          && sbatch --usage
echo 'Testing: sbcast'          && sbcast -V
echo 'Testing: scancel'         && scancel -fA 1
echo 'Testing: scontrol'        && scontrol all
echo 'Testing: sreport'         && sreport verbose
echo 'Testing: strigger'        && strigger --get

echo 'Testing: munge'           && slurm.munge -s test
echo 'Testing: unmunge'         && unmunge -K
echo 'Testing: remunge'        && slurm.remunge -Z
echo 'Testing: mungekey'        && slurm.mungekey -v -c -k /tmp/test-the-munge.key
