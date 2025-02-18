# Copyright (C) 2025 Cesar Perez

ARG DEBIAN_VERSION=stable
FROM debian:${DEBIAN_VERSION}-slim

RUN apt-get update
RUN apt-get install --quiet --yes \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    git \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev
