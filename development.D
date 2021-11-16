FROM ghcr.io/isisscientificcomputing/autoreduce

VOLUME /ar

RUN apt install -y openssh-server