FROM ubuntu:bionic

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update &&\
  apt-get install -y wget git libmysqlclient-dev gcc software-properties-common &&\
  apt-get clean

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /tmp/ &&\
  bash /tmp/Miniconda3-latest-Linux-x86_64.sh -u -b -p /opt/miniconda &&\
  rm /tmp/Miniconda3-latest-Linux-x86_64.sh

RUN . /opt/miniconda/bin/activate &&\
  conda create -n mantid -c conda-forge -c scipp mantid-framework python=3.7 &&\
  conda clean --all

ADD ./setup.py /autoreduce/setup.py
ADD ./build /autoreduce/build

# RUN . /opt/miniconda/bin/activate mantid && python -V
RUN . /opt/miniconda/bin/activate && conda activate mantid && python -V &&\
  python3.7 -m pip install --no-cache-dir --ignore-installed PyYAML -e autoreduce &&\
  python3.7 -m pip install --no-cache-dir mysqlclient debugpy matplotlib toml

CMD python3 /autoreduce/queue_processors/queue_processor/queue_listener.py &
