FROM ghcr.io/autoreduction/autoreduce:latest
RUN export DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive
RUN python3 -m pip install pytest
RUN python3 -m pip install parameterized
USER isisautoreduce
