![alt text](.github/slurm.png)

<p align="center"><b>This is the snap for the Slurm Workload Manager</b>, <i>"The Slurm Workload Manager (formerly known as Simple Linux Utility for Resource Management or SLURM), or Slurm, is a free and open-source job scheduler for Linux and Unix-like kernels, used by many of the world's supercomputers and computer clusters."</i></p>

## Install

### Snap Store

Slurm is available to download from the [Snap Store](https://snapcraft.io/slurm). All Snaps installed from the Snap Store receive automatic updates via Snapd and are automatically aliased.

```bash
snap install slurm --classic
```

The Snap Store has multiple channels for different release candidates (edge, beta, stable, etc).

### Github

The Slurm Snap is also released nightly to Github [Releases](https://github.com/omnivector-solutions/snap-slurm/releases).

Keep in mind that if you install the Slurm Snap from a Github Release, you will **not** recieve automatic updates or automatic Snap aliasing.

<!-- TODO: Re-add interfaces section when relevant -->
<!-- ### Connect Interfaces
Snap interfaces are used by _strictly confined_ Snaps to communicate with various parts of the system outside the Snap sandbox.

A _strictly confined_ Snap requires these interfaces to be connected but the _Classic_ Snap does not.

```bash
snap connect slurm:network-control
snap connect slurm:system-observe # For NHC health checks
snap connect slurm:hardware-observe # For NHC health checks
``` -->

## Basic Usage

This snap supports running different components of slurm depending on what `snap.mode` has been configured.

### Set `snap.mode` Config
The following `snap.mode` values are supported:
* `none`
* `all`
* `login`
* `munged`
* `slurmdbd`
* `slurmdbd+mysql`
* `slurmd`
* `slurmrestd`

To configure this snap to run a different set of daemons, just set the `snap.mode`:
```bash
snap set slurm snap.mode=all
```
The above command configures the `snap.mode` to `all` mode. This runs all of the Slurm daemons including MySQL and Munged in an all-in-one local development mode.

### Example Usage

```bash
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
debug*       up   infinite      1   idle slurm-dev 
```
```bash
$ scontrol ping
Slurmctld(primary) at slurm-dev is UP
```
```bash
$ srun -pdebug -n1 -l hostname
0: slurm-dev
```

The following example will only work with the `classic` Snap:

```bash
$ srun --uid 1000 -N1 -l uname -r
0: 5.4.0-31-generic
```

### Logging

All services log their stdout to journald. The logs can be accessed `snap logs`, example:

    $ snap logs slurm.slurmrestd

or by using using the journal directly:

    $ journalctl -eu snap.slurm.slurmrestd

Certain services also write to log files which is only readble by root for security purposes. The following services write to log files:

- nhc
- slurmd
- slurmdbd
- slurmctld

Log files are found at `/var/snap/slurm/common/var/log/`. For example, the log for slurmctld can be found at:

    /var/snap/slurm/common/var/log/slurm/slurmctld.log

### Configuration

Configuration files can be found in under `/var/snap/slurm/common/var/etc`.

For testing purposes, you can manually edit the `.conf` files located under `/var/snap/slurm/common/etc/`. However, **any** changes you make to `slurm.conf` or `slurmdbd.conf` will be overwritten when the `snap.mode` is changed.

Persistent changes to the Slurm configuration files are made using the `.yaml` files located under `/var/snap/slurm/common/etc/slurm-configurator`. For example, if you wanted to change the port slurmd runs on, you would edit the `slurm.yaml` file here:

    /var/snap/slurm/common/etc/slurm-configurator/slurm.yaml

To apply any configuration changes to the above file, you need to restart the slurm daemons that run inside the snap. Assuming the `snap.mode=all`, run the following command:

    snap set slurm snap.mode=all

This will render the slurm.yaml -> slurm.conf and restart the appropriate daemons.

To modify the Node Healthcheck configuration, edit the file located here:

    /var/snap/slurm/common/etc/nhc/nhc.conf

NHC is run automatically by Slurmd and changes to `nhc.conf` take effect immediately.

When configuring Slurm to run as part of a large-scale compute cluster, remember to adjust the system configuration files according. More information about this can be found [here](https://slurm.schedmd.com/big_sys.html). 

## Appendix

### Daemons included in the Snap

You can interact with individual services using `snap services`. Example:

```bash
$ snap services slurm
Service           Startup  Current  Notes
slurm.munged      enabled  active   -
slurm.mysql       enabled  active   -
slurm.slurmctld   enabled  active   -
slurm.slurmd      enabled  active   -
slurm.slurmdbd    enabled  active   -
slurm.slurmrestd  enabled  active   -
```

### User Commands available from the Snap

The following commands are available from the snap:

* `munge`
* `remunge`
* `sacct`
* `sacctmgr`
* `salloc`
* `sattach`
* `sbatch`
* `sbcast`
* `scancel`
* `scontrol`
* `sdiag`
* `sinfo`
* `sprio`
* `squeue`
* `sreport`
* `srun`
* `sshare`
* `sstat`
* `strigger`
* `version`

If you are using the Slurm Snap installed from the Github Release, all commands must be namespaced with `slurm.`. Example:

```bash
$ slurm.srun -p debug -n 1 uname -a
```

### Copyright
* OmniVector Solutions <admin@omnivector.solutions>
