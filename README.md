<h1 align="center">
  <img src="https://www.massey.ac.nz/~theochem/simurg/lib/exe/fetch.php/images/software/slurm.png" alt="Slurm">
  <br />
</h1>

<p align="center"><b>This is the snap for the Slurm Workload Manager</b>, <i>"The Slurm Workload Manager (formerly known as Simple Linux Utility for Resource Management or SLURM), or Slurm, is a free and open-source job scheduler for Linux and Unix-like kernels, used by many of the world's supercomputers and computer clusters."</i></p>

# Install

    sudo snap install slurm

([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

<p align="center">Built & Published with 💝 by <a href="https://www.omnivector.solutions">OmniVector Solutions</a>.</p>

## Usage

Upon installation this snap only runs munged until configured to run in a supported `snap.mode`.

The following `snap.mode`'s are supported:
* slurmdbd
* slurmctld
* slurmd
* slurmrestd
* all
* none

To configure this snap to run a different Slurm daemon, just set the `snap.mode`:
```bash
sudo snap set slurm snap.mode=all
```
The above command configures this snap to run in `all` mode (this runs all of the Slurm daemons in a all in one local development mode.)

`all` mode is a core feature of this software, as there currently exists no other way to provision a fully functioning slurm cluster for development use.


### Supported Daemons

* slurmdbd/mysql
* slurmctld
* slurmd
* slurmrestd

### Supported User Commands

* sacct
* sacctmgr
* salloc
* sattach
* sbatch
* sbcast
* scancel
* scontrol
* sdiag
* sinfo
* sprio
* squeue
* sreport
* srun
* sshare
* sstat
* strigger

### Other Components

##### Daemons

* munged

##### User Commands

* slurm-version
* mungekey
* munge
* unmunge
* mysql-client
* snap-mysqldump

## Remaining Tasks

* [ ] Support strict confinement
* [ ] Built-in [NHC](https://github.com/mej/nhc) service
* [ ] Automated builds with TravisCI
* [ ] Publish to Snap Store

#### Copyright
* Omnivector Solutions <admin@omnivector.solutions>
