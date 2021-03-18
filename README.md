# Containers for Autoreduction

This repository contains some containers that are used to deploy different services of Autoreduction.

### qp_mantid_python36.D
This is a base container that installs:
- Python 3.6 on top of a Ubuntu 18.04 (bionic) image.
- Mantid software, which is a dependency for running reductions.
- Autoreduce and configures the run script that can be used to start the service.


### Binding paths
There are a few folders that need to be mounted:
- The Autoreduce source code
- The ISIS Archive
- The CEPH mount

An example run command can be seen in the Makefile.

### Makefile
Contains commands that assume you already have Docker and [Singularity](https://sylabs.io/guides/3.7/user-guide/quick_start.html#install-system-dependencies)
installed, and the Autoreduce repo is at `../`, relative to this repository (this means you need to clone THIS inside the Autoreduce repository!!).
