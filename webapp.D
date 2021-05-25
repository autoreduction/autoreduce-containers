FROM autoreduction/base

ADD ./setup.py /autoreduce/setup.py

RUN python3 -m pip install --no-cache-dir gunicorn && python3 -m pip install --no-cache-dir -e /autoreduce

CMD python3 /autoreduce/autoreduce_webapp/manage.py runserver 8000
