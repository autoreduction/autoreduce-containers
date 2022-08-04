# Don't use alpine based images: Python was designed for glibc and is very slow in them.
# Always use the -slim images if you can: they are the best compromise between performance and image size.
FROM python:3.8.12-slim

# This is to print directly to stdout instead of buffering output
ENV PYTHONUNBUFFERED 1

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update &&\
    apt-get install -y \
      wget \
      gnupg \
      git \
      software-properties-common \
      python3-dev \
      default-libmysqlclient-dev \
      build-essential

# Create non-root user and configure it for the project to run correctly with it.
# ref: https://github.com/moby/moby/issues/5419#issuecomment-41478290
# note: this user ID shouldn't be changed as it's expected by the rest of the system
RUN groupadd -g 998 docker \
    && groupadd -g 880844730 isisautoreduce \
    && useradd -u 880844730 -g 880844730 -m -s /bin/bash --no-log-init isisautoreduce \
    && usermod -aG docker isisautoreduce

USER isisautoreduce
WORKDIR /home/isisautoreduce

# .local/bin is where local pip packages put their executables
ENV PATH=/home/isisautoreduce/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Note: mysqlclient is required when connecting to the production DB
RUN python3 -m pip install --user --no-cache-dir mysqlclient debugpy
