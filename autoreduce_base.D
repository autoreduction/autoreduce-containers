FROM ubuntu:bionic

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update &&\
  apt-get install -y wget gnupg git software-properties-common libmysqlclient-dev &&\
  wget -O - http://apt.isis.rl.ac.uk/2E10C193726B7213.asc | apt-key add - &&\
  apt-get install -y python3.6 python3-pip &&\
  python3.6 -m pip install --upgrade pip &&\
  apt-get clean

# --no-log-init needed when a user with large UID is created
# ref: https://github.com/moby/moby/issues/5419#issuecomment-41478290
# note: this user ID shouldn't be changed as it's expected by the rest of the system
RUN useradd -m --no-log-init -s /bin/bash -u 880844730 isisautoreduce
USER isisautoreduce
WORKDIR /home/isisautoreduce

# .local/bin is where local pip packages put their executables
ENV PATH=/home/isisautoreduce/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Note: mysqlclient is required when connecting to the production DB
RUN python3 -m pip install --user --no-cache-dir mysqlclient debugpy
