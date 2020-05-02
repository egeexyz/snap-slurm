# snap-slurm
Find herewithin the snap that encapsulates Omnivector Solutions packaging of Schedmd's Slurm Workload Manager.


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


## Configuration

#### License
* AGPLv3 - See `LICENSE` file

#### Copyright
* Omnivector Solutions <admin@omnivector.solutions>
