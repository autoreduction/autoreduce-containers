FROM autoreduction/base

RUN export DEBIAN_FRONTEND=noninteractive && apt-add-repository "deb [arch=amd64] http://apt.isis.rl.ac.uk $(lsb_release -c | cut -f 2) main" &&\
  apt-add-repository ppa:mantid/mantid &&\
  apt-get update &&\
  apt-get install -y libglu1-mesa mantid &&\
  apt-get clean &&\
  cp /opt/Mantid/bin/Mantid.properties /opt/Mantid/lib/Mantid.properties

ENV PYTHONPATH=/opt/Mantid/scripts/:/opt/Mantid/scripts/Diffraction/:/opt/Mantid/bin:/opt/Mantid/lib:/opt/Mantid/plugins:/opt/Mantid/scripts/SANS/:/opt/Mantid/scripts/Inelastic/:/opt/Mantid/scripts/ExternalInterfaces

CMD python3 /autoreduce/queue_processors/queue_processor/queue_listener.py
