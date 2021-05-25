FROM autoreduction/base

ADD ./setup.py /autoreduce-frontend/setup.py

RUN python3 -m pip install --no-cache-dir gunicorn && python3 -m pip install --no-cache-dir -e /autoreduce-frontend

CMD python3 /autoreduce-frontend/autoreduce_webapp/manage.py runserver 8000
