# Setup python env
from python:3.8.5-buster as build

ENV PYTHONUNBUFFERED=1
ENV PIPENV_VENV_IN_PROJECT=1

RUN set -ex && apt-get -y update && apt-get -y install git wget default-libmysqlclient-dev

WORKDIR /app

# Install the python dependencies
RUN set -ex && pip3 install virtualenv==20.0.30 && pip3 install pipenv==2020.8.13
COPY Pipfile /app/Pipfile
COPY Pipfile.lock /app/Pipfile.lock
RUN set -ex && pipenv install --deploy --python /usr/local/bin/python

from python:3.8.5-slim-buster as application

ENV PYTHONUNBUFFERED=1
ENV PIPENV_VENV_IN_PROJECT=1
ENV TZ America/New_York
ENV AWS_DEFAULT_REGION us-east-1
ENV PATH=.venv/bin:$PATH

RUN set -ex && apt-get -y update && apt-get -y install default-libmysqlclient-dev wget procps
RUN set -ex && pip3 install virtualenv==20.0.30 && pip3 install pipenv==2020.8.13


WORKDIR /app
COPY --from=build /app /app/
COPY . /app

RUN set -ex \
    && mkdir -p /var/lib/brat/data/transcripts \
    && mkdir -p /var/lib/brat/work \
    && ln -s /var/lib/brat/data data \
    && ln -s /var/lib/brat/work work \
    && cp /app/configurations/aiera_transcripts/*.conf /var/lib/brat/data/ \
    && cp /app/configurations/aiera_transcripts/*.conf /var/lib/brat/data/transcripts