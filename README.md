# Containers for Autoreduction

This repository contains some containers that are used to deploy different services of Autoreduction.

### python36.img
This is a base container that installs Python 3.6 on top of a Ubuntu 18.04 (bionic) image.

### mantid.img
This builds on the base container and install the Mantid software, which is a dependency for running reductions.

### queue_processor.img
This finally installs Autoreduce and configures the run script that can be used to start the service. However it requires binding of the source repository via `--bind`.

An example run command can be seen in the Makefile.

### Makefile
Contains commands that assume you already have [Singularity](https://sylabs.io/guides/3.7/user-guide/quick_start.html#install-system-dependencies)
installed, and the Autoreduce repo is at `../autoreduce`, relative to this repository. If `autoreduce` is anywhere else you'll have to grep for
`../autoreduce` and replace it with the correct path.
