FROM ubuntu:bionic

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update &&\
  apt-get install -y wget gnupg git software-properties-common libmysqlclient-dev &&\
  wget -O - http://apt.isis.rl.ac.uk/2E10C193726B7213.asc | apt-key add - &&\
  apt-get install -y python3.6 python3-pip &&\
  python3.6 -m pip install --user --upgrade pip &&\
  apt-get clean

RUN export DEBIAN_FRONTEND=noninteractive && apt-add-repository "deb [arch=amd64] http://apt.isis.rl.ac.uk $(lsb_release -c | cut -f 2) main" &&\
  apt-add-repository ppa:mantid/mantid &&\
  apt-get update &&\
  apt-get install -y libglu1-mesa mantid &&\
  apt-get clean &&\
  cp /opt/Mantid/bin/Mantid.properties /opt/Mantid/lib/Mantid.properties

ADD ./setup.py /autoreduce/setup.py
ADD ./build /autoreduce/build

# Install Autoreduce and reinstall h5py to have the correct version that Mantid depends on
RUN python3 -m pip install --no-cache-dir mysqlclient debugpy &&\
    python3 -m pip install --ignore-installed PyYAML --no-cache-dir -e /autoreduce &&\
    python3 -m pip uninstall -y h5py && apt install --reinstall -y python3-h5py
