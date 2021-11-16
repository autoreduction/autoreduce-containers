FROM ghcr.io/isisscientificsoftware/autoreduce

VOLUME /ar

RUN apt install -y openssh-server