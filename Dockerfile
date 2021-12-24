FROM ghcr.io/autoreduction/autoreduce:latest
RUN export DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive
RUN python3 -m pip install autoreduce-qp==22.0.0.dev53 --extra-index-url https://api.packagr.app/public
RUN python3 -m pip install pytest
RUN python3 -m pip install parameterized
USER isisautoreduce
