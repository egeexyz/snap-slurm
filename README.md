![alt text](.github/slurm.png)

<p align="center"><b>This is the snap for the Slurm Workload Manager</b>, <i>"The Slurm Workload Manager (formerly known as Simple Linux Utility for Resource Management or SLURM), or Slurm, is a free and open-source job scheduler for Linux and Unix-like kernels, used by many of the world's supercomputers and computer clusters."</i></p>

<!-- Re-add the section below once we have a delivery method -->
<!-- # Install

    sudo snap install slurm

([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

<p align="center">Built & Published with 💝 by <a href="https://www.omnivector.solutions">OmniVector Solutions</a>.</p> -->

[![slurm](https://snapcraft.io//slurm/badge.svg)](https://snapcraft.io/slurm)
[![slurm](https://snapcraft.io//slurm/trending.svg?name=0)](https://snapcraft.io/slurm)
[![CircleCI](https://circleci.com/gh/omnivector-solutions/snap-slurm.svg?style=svg)](https://circleci.com/gh/omnivector-solutions/snap-slurm)

## Classic or Strict?

We currently support two different versions of the Slurm Snap: **strict** and **classic**.

The **strict** Snap is the default _stable_ version and supports basic use-cases and Slurm functionality.

The **classic** Snap is for advanced uses-cases where switching UID is required as the **strict** Snap [cannot assume other UID](https://forum.snapcraft.io/t/can-a-confined-snap-run-as-a-different-uid-and-or-guid)'s effectively.

If you need to run Slurm jobs under the context of a different user, use the **classic** version.

## Install

### Snapstore

[Currently](https://forum.snapcraft.io/t/request-for-classic-confinement-slurm), only the **strict** Snap is available from the Snapstore. All Snaps installed from the Snapstore receive automatic updates via Snapd.

```bash
sudo snap install slurm
```

If you need the *classic* Snap, download and install it from [Github Releases](https://github.com/omnivector-solutions/snap-slurm/releases).

### Github

Both versions of the Snap are available to download from Github under [Releases](https://github.com/omnivector-solutions/snap-slurm/releases).

Keep in mind that if you install the Slurm Snap from a Github Release, you will **not** recieve automatic updates.

### Connect Interfaces

Snap interfaces are used by _strictly confined_ Snaps to communicate with various parts of the system outside the Snap sandbox.

A _strictly confined_ Snap requires these interfaces to be connected but the _Classic_ Snap does not.

```bash
sudo snap connect slurm:network-control
sudo snap connect slurm:system-observe # For NHC health checks
sudo snap connect slurm:hardware-observe # For NHC health checks
```

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
* `slurmctld`
* `slurmd`
* `slurmrestd`

To configure this snap to run a different set of daemons, just set the `snap.mode`:
```bash
sudo snap set slurm snap.mode=all
```
The above command configures the `snap.mode` to `all` mode. This runs all of the Slurm daemons including MySQL and Munged in a all in one local development mode.

`all` mode is a core feature of this software, as there currently exists no other way to provision a fully functioning slurm cluster for development use.

When the above steps have been completed you will have a Slurm deploy running inside the snap. Try running `snap services` to verify all of the daemons are `active`.

### Examples

At this point you can start executing commands against the cluster. Lets try a few:
```bash
$ slurm.sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
debug*       up   infinite      1   idle ubuntu-dev 
```
```bash
$ slurm.scontrol ping
Slurmctld(primary) at ubuntu-dev is UP
```
```bash
$ slurm.srun -pdebug -n1 -l hostname
0: ubuntu-dev
```

The following example will run under uid 1000, it will only work with the `classic` version of the Slurm Snap:

```bash
$ slurm.srun --uid 1000 -N1 -l uname -r
0: 5.4.0-31-generic
```

### Logging

The application logs can be found in under `$SNAP_COMMON/var/log`. For example, the log for slurmctld can be found at:

    /var/snap/slurm/common/var/log/slurm/slurmctld.log

Service logs can be accessed using `snap logs slurm` or by using journalctl:

    $ journalctl -eu snap.slurm.slurmrestd

### Configuration

Configuration files can be found in under `$SNAP_COMMON/var/etc`.

The default Slurm configuration is adequate for development and testing. In production deployments, you will need to adjust the Slurm configuration files to match your hardware.

For testing purposes, you can manually edit the `.conf` files located under `$SNAP_COMMON/etc/log`. However, **any** changes you make to `slurm.conf` or `slurmdbd.conf` will be overwritten when the `snap.mode` is changed.

Persistent changes to the Slurm configuration files are made using the `.yaml` files located under `$SNAP_COMMON/etc/slurm-configurator`. For example, if you wanted to change the port slurmd runs on, you would edit the `slurm.yaml` file here:

    /var/snap/slurm/common/etc/slurm-configurator/slurm.yaml

To apply any configuration changes to the above file, you need to restart the slurm daemons that run inside the snap. Assuming the `snap.mode=all`, run the following command:

    sudo snap set slurm snap.mode=all

This will render the slurm.yaml -> slurm.conf and restart the appropriate daemons.

To modify the Node Healthcheck configuration, edit the file located here:

    /var/snap/slurm/common/etc/nhc/nhc.conf

NHC is run automatically by Slurmd and changes to `nhc.conf` take effect immediately.

## Appendix

### Daemons included in the Snap

You can interact with individual services using `systemctl`. Example:

```bash
$ systemctl status snap.slurm.slurmd
```

Note that all services are prefixed with `snap.slurm`.

* munged
* mysql
* slurmctld
* slurmd
* slurmrestd

### User Commands available from the Snap

Currently, all commands must be namespaced with `slurm.`. Example:

```bash
$ slurm.srun -p debug -n 1 uname -a
```

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
* version

### Copyright
* OmniVector Solutions <admin@omnivector.solutions>
