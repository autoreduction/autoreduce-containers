FROM autoreduction/base

ADD ./requirements.txt /requirements.txt

RUN python3 -m pip install -r /requirements.txt
