# Copyright (C) 2025 Cesar Perez

SHELL = bash

NAME := $(shell poetry version | cut --delimiter ' ' --field 1)
VERSION := $(shell poetry version | cut --delimiter ' ' --field 2)

PACKAGE_NAME := $(shell echo ${NAME} | sed -e 's/-/_/g' -)
PACKAGE_VERSION :=  ${VERSION}

DOCKER_REGISTRY = ttyrho
IMAGE_NAME = ${NAME}
IMAGE_VERSION = ${VERSION}

PIP_REPOSITORY =
PIP_INDEX =
PIP_EXTRA_INDEX =

PYTHON_VERSION := 3.12

DIST_DIR = dist
SRC_DIR = heelo

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PHONY: setup install

setup:
	@echo "Using Python ${PYTHON_VERSION}"
	@poetry env use -- ${PYTHON_VERSION}

install: setup
	@poetry install

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PHONY: checks style-checks type-checks

checks: style-checks type-checks

style-checks: install
	@poetry run flake8 ${SRC_DIR}

type-checks: install
	@poetry run mypy ${SRC_DIR}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PHONY: package source-package wheel-package publish

package: source-package wheel-package

source-package:
	@poetry build --format sdist --output ${DIST_DIR}

wheel-package:
	@poetry build --format wheel --output ${DIST_DIR}

publish: package

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PHONY: image push-image _remove-image

image: _remove-image source-package
	@docker buildx build \
		--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
		--build-arg PIP_REPOSITORY=${PIP_REPOSITORY} \
		--build-arg PIP_INDEX=${PIP_INDEX} \
		--build-arg PIP_EXTRA_INDEX=${PIP_EXTRA_INDEX} \
		--build-arg PACKAGE_NAME=${PACKAGE_NAME} \
		--build-arg PACKAGE_VERSION=${PACKAGE_VERSION} \
		--tag ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_VERSION} \
		.

push-image: image
	@docker image rm ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_VERSION}

_remove-image:
	@-docker image rm ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_VERSION}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PHONY: clean mrproper

clean:
	@find ${SRC_DIR} -name __pycache__ | xargs rm -rf

mrproper: clean
	@rm -rf .venv ${DIST_DIR}
	@rm -f poetry.lock
