FROM autoreduction/base

ENV PYTHONIOENCODING=UTF-8
ENV LC_CTYPE="en_US.UTF-8"

RUN LC_CTYPE="en_US.UTF-8" python3.6 -m pip install ansible
RUN git clone https://github.com/isisScientificComputing/autoreduce-workspace /ar
