#!/bin/bash

snap install --dangerous /tmp/slurm_20.02.1_amd64.snap
snap connect slurm:network-control
snap connect slurm:system-observe
snap connect slurm:hardware-observe