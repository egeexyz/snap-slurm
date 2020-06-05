#!/bin/bash

dnf install -y epel-release
dnf upgrade -y
dnf install -y snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap
