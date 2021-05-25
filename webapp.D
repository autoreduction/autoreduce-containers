FROM autoreduction/base

ADD ./setup.py /autoreduce-frontend/setup.py

RUN python3 -m pip install --no-cache-dir gunicorn autoreduce-webapp==21.1.4

CMD autoreduce-webapp-manage runserver 8000
