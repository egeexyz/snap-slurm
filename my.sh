#!/bin/bash


set -e



sudo snap connect slurm:network-control core:network-control
sudo snap connect slurm:process-control core:process-control
