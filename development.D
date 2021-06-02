FROM autoreduction/base

ADD ./autoreduce/ /autoreduce/
ADD ./autoreduce-frontend/ /autoreduce-frontend/

# add --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple for packages in test.pypi.org
RUN python3 -m pip install -e /autoreduce/ -r /autoreduce/requirements.txt
RUN python3 -m pip install -e /autoreduce-frontend/ -r /autoreduce-frontend/requirements.txt
