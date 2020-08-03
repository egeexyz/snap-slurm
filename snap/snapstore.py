#!/usr/bin/env python3
"""Uploads the Snap to the Snapstore and reports any warnings or failures."""

import subprocess
import sys

if __name__ == "__main__":
    cmd = ["snapcraft", "upload", "/home/circleci/project/slurm.snap", "--release", sys.argv[1]]
    try:
        subprocess.check_output(cmd).decode()
    except subprocess.CalledProcessError as err:
        output = err.output.decode()
        if "already been uploaded" in output:
            print("This Snap revision has already been uploaded, skipping...")
        else:
            print(output)
            exit(err.returncode)
