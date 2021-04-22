from autoreduction/base

RUN python3 -m pip install gunicorn

CMD python3 /autoreduce/WebApp/autoreduce_webapp/manage.py runserver 8000
