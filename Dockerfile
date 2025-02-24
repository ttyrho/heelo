# Copyright (C) 2025 Cesar Perez

ARG PYTHON_VERSION=latest
FROM python:${PYTHON_VERSION}-slim

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Package sources configuration

ARG PIP_REPOSITORY
ARG PIP_INDEX
ARG PIP_EXTRA_INDEX

ENV PIP_TRUSTED_HOST=${PIP_REPOSITORY}
ENV PIP_INDEX_URL=${PIP_INDEX}
ENV PIP_EXTRA_INDEX_URL=${PIP_EXTRA_INDEX}

RUN pip install --upgrade pip

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Application installation

ARG PACKAGE_NAME
ARG PACKAGE_VERSION

COPY dist/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz /tmp

RUN pip install /tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
&& rm /tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz
