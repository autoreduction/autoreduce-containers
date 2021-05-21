FROM ubuntu:bionic

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update &&\
  apt-get install -y wget gnupg git software-properties-common libmysqlclient-dev &&\
  wget -O - http://apt.isis.rl.ac.uk/2E10C193726B7213.asc | apt-key add - &&\
  apt-get install -y python3.6 python3-pip &&\
  python3.6 -m pip install --upgrade pip &&\
  apt-get clean

ADD ./setup.py /autoreduce/setup.py

# Install Autoreduce and reinstall h5py to have the correct version that Mantid depends on
# Note: libmysqlclient-dev & mysqlclient are required when connecting to the production DB
RUN python3 -m pip install --no-cache-dir mysqlclient debugpy
