FROM docker.io/python:buster

RUN apt-get update && apt-get install -y apache2 libapache2-mod-wsgi-py3 less vim

WORKDIR /usr/local/src/orihime-django
ENV PYTHON_PATH=/usr/local/src/orihime-django
ENV DJANGO_SETTINGS_MODULE=orihime.settings

# Not expected to change much
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY entrypoint.bash entrypoint.bash

# May change lots
COPY zz-orihime-django.conf /etc/apache2/conf-enabled/zz-orihime-django.conf
COPY apache2.conf /etc/apache2/apache2.conf

ARG GIT_URL=https://github.com/dacodas/orihime.git
ENV GIT_URL=$GIT_URL

ARG GIT_BRANCH=master
ENV GIT_BRANCH=$GIT_BRANCH

RUN git clone --depth 1 --branch $GIT_BRANCH $GIT_URL

CMD ["./entrypoint.bash"]