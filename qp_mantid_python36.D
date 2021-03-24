FROM ubuntu:bionic

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update &&\
  apt-get install -y wget gnupg software-properties-common &&\
  wget -O - http://apt.isis.rl.ac.uk/2E10C193726B7213.asc | apt-key add - &&\
  apt-get install -y python3.6 python3-pip &&\
  python3.6 -m pip install --user --upgrade pip &&\
  apt-get clean

RUN export DEBIAN_FRONTEND=noninteractive && apt-add-repository "deb [arch=amd64] http://apt.isis.rl.ac.uk $(lsb_release -c | cut -f 2) main" &&\
  apt-add-repository ppa:mantid/mantid &&\
  apt-get update &&\
  apt-get install -y libglu1-mesa mantid &&\
  cp /opt/Mantid/bin/Mantid.properties /opt/Mantid/lib/Mantid.properties

ADD ./setup.py /autoreduce/setup.py
ADD ./build /autoreduce/build

RUN apt-get install -y git libmysqlclient-dev &&\
  pip3 install --ignore-installed PyYAML -e autoreduce &&\
  pip3 install mysqlclient debugpy

ADD ./autoreduce-containers/Mantid.user.properties /Mantid.user.properties

# Disabled a warning when importing Mantid
ENV HDF5_DISABLE_VERSION_CHECK 1
# Specifies a custom location for the user properties, but
# currently disabled to allow easier addition of paths.
# This means that when run with Singularity, Mantid will look for ~/.mantid/Mantid.user.properties
# and when run with Docker you need to specify it with -e MANTIDPROPERTIES=/Mantid.user.properties
# ENV MANTIDPROPERTIES /Mantid.user.properties

CMD python3 /autoreduce/queue_processors/queue_processor/queue_listener.py &
