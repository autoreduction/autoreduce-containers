FROM autoreduction/base

ADD ./requirements.txt /requirements.txt

RUN python3 -m pip install -r /requirements.txt

RUN wget https://chromedriver.storage.googleapis.com/87.0.4280.20/chromedriver_linux64.zip && unzip chromedriver_linux64.zip && export PATH=$PATH:./chromedriver_linux64/