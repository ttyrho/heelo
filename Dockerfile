# Copyright (C) 2025 Cesar Perez

ARG PYTHON_VERSION=3.13
FROM python:${PYTHON_VERSION}-slim

RUN pip install --upgrade pip

RUN pip install poetry
