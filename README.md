# Containers for Autoreduction

This repository contains some containers that are used to deploy different services of Autoreduction.

The containers and `ansible` roles for the [autoreduce-frontend](https://github.com/autoreduction/autoreduce-frontend) and [autoreduce-qp](https://github.com/autoreduction/autoreduce) are stored in their repositories. This repository contains the container build files that are not tied to a specific part of the service.

## Quickstart common
- If you haven't the code, see the [start here section](https://github.com/autoreduction/autoreduce/wiki/Start-here-(getting-the-code---installation)#getting-the-code)
- Either after or while that's happening you will have to copy the Mantid.user.properties to ~/.mantid/Mantid.user.properties
  - This provides search paths for Mantid to find data from the Archive in specific locations
- Install Docker, this should be enough for development
- Install Singularity, if you need to build the production images. There are example commands in the Makefile, but it's best to refer to the official documentation https://sylabs.io/docs/
  - You might also need to run Singularity if you are experiencing issues with Docker, such as failing to mount `/isis` inside the container. An alternative solution is to mount a local folder

## Quickstart with Docker only
Run `make`, then wait until the error that you don't have singularity executable, this is fine as we will run it through Docker only.

Then run it with the command below, but make sure to change `~/dev/autoreduce/` to wherever your autoreduce folder is.
```
docker run --network=host -v ~/dev/autoreduce/:/autoreduce -v /isis:/isis -it autoreduction/qp:latest
```

You can check the `.def` files to get an idea of what commands the Singularity containers execute on startup.

**This should not be used in production to avoid running as root.**

Locally, it is more convenient to run in Docker, because it lets you modify the image after build (the Singularity one is made immutable),
although you may find yourself in need of running a few `chown`s to access some output files, as they will be owned by `root` by default.

## Preparing images for production with Docker & Singularity
1. Install Docker & Singularity - `make deps` attempts to simplify this, but the instructions may go out of date in the future
2. Build the images locally with the relevant `make` command. The Singularity image is built locally as part of this step.
3. Run the relevant [Ansible playbook](https://github.com/autoreduction/ansible). This will copy & run the Singularity image on the hosts.

Singularity is used as production runtime as it enforces running as a user, rather than `root`.

### Binding paths
There are a few folders that need to be mounted:
- The Autoreduce source code
- The ISIS Archive
- The CEPH mount

An example run command can be seen in the Makefile.

### Makefile
Contains commands that assume you already have Docker and [Singularity](https://sylabs.io/guides/3.7/user-guide/quick_start.html#install-system-dependencies)
installed, and the Autoreduce repo is at `../`, relative to this repository (this means you need to clone THIS inside the Autoreduce repository!!).

## Database Backup and Restore
Required: Passphrase, dbmanage.sif image

The dbmanage.sif image contains 2 apps within it: backup and restore. They both use Django to do the DB operations.

### Backup
Example:

```
singularity run [--env AUTOREDUCTION_PRODUCTION=1] --env AUTOREDUCE_DB_PASSPHRASE=[PASSPRHASE] --bind ../autoreduce:/autoreduce/ --app backup dbmanage.sif

# Note: only add --env AUTOREDUCTION_PRODUCTION=1 if targeting the production DB (or another remote DB that isn't SQLite3)
singularity run --env AUTOREDUCTION_PRODUCTION=1 --env AUTOREDUCE_DB_PASSPHRASE=apples --bind ../autoreduce:/autoreduce/ --app backup dbmanage.sif
```

The backup will run a `python manage.py dumpdata` on the current Django database. To target production make sure you have added `--env AUTOREDUCTION_PRODUCTION=1` to the singularity run.

The output file is encrypted with the passphrase after the `dumpdata` command, and the name will be something starting with `backup` and ending in `.gpg`.

The general pattern of the name is: `backup_DATE_DBENGINE_DBNAME.json.gpg`. For the naming generation check the `dbmanage.def` `%apprun backup` section. A breakdown:

```
backup_2021-04-11T07:33:31+00:00_django.db.backends.mysql_autoreduction.json.gpg

`backup` - all files start with this, mostly for easy tab-completion

`2021-04-11T07:33:31+00:00` - timestamp of when the backup was made

`django.db.backends.mysql` - engine of the DB

`autoreduction` - name of the DB

`.json` - format of the unencrypted data dump

`.gpg` - shows that file was encrypted with gpg
```


### Restore

Example:

```
singularity run [--env AUTOREDUCTION_PRODUCTION=1] --env AUTOREDUCE_DB_PASSPHRASE=[PASSPRHASE] --bind ../autoreduce:/autoreduce/ --app restore dbmanage.sif [ENCRYPTED FILE]

# Note: this example command will restore the production data in a local SQLite3 DB!
singularity run --env AUTOREDUCE_DB_PASSPHRASE=apples --bind ../autoreduce:/autoreduce/ --app restore dbmanage.sif backup_2021-04-11T07:33:31+00:00_django.db.backends.mysql_autoreduction.json.gpg
```

Note: A backup with `AUTOREDUCTION_PRODUCTION=1` can be restored on any database with the same migrations (i.e. local SQLite3.db).
This is best done on an empty database, or you might get some unique constraint errors (e.g. if Experiment ID already exists).
