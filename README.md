# Containers for Autoreduction

This repository contains some containers that are used to deploy different services of Autoreduction.

## Quickstart common
- Checkout https://github.com/isisScientificComputing/autoreduce-containers next to the autoreduce folder!
  - So that you can do `cd ../autoreduce` from the containers folder
- Either after or while that's happening you will have to copy the Mantid.user.properties to ~/.mantid/Mantid.user.properties
- Install Docker, this should be enough for development
- Install Singularity, if you need to build the production images

## Quickstart with Docker & Singularity
Run `make`, then `make run`. This is used for production deployment as Singularity enforces running as a user, rather than `root`.

## Quickstart with Docker only
Run `make`, then wait until the error that you don't have singularity executable, this is fine as we will run it through Docker only.

Then run it with the command below, but make sure to change `~/dev/autoreduce/` to wherever your autoreduce folder is.
```
docker run --network=host -v ~/dev/autoreduce/:/autoreduce -v /isis:/isis -it local/python36:latest
```

This should not be used in production to avoid running as root.

### qp_mantid_python36.D
This is the container definition file and it installs:
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
