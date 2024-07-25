# Default target
.DEFAULT_GOAL := help

# Include .env if it exists
-include .env

# Needed for CI
SHELL := /bin/bash

# Python defaults
PYTHON3 ?= $(shell which python3)
INTERVIEW_TYPE_DIR := interview_tests/${INTERVIEW_TYPE}
USE_VENV := cd $(INTERVIEW_TYPE_DIR) && source venv/bin/activate &&

SRC_DIR := src
TEST_DIR := tests
DIRS_TO_LINT := $(SRC_DIR) $(TEST_DIR)

# Container labelling convention:
#		`<tag>` if git tag set, otherwise `<branch>-<shortsha>`
# 	e.g. `v1.0.0` (tag), `main-aabbcc7`, `nays_feature_branch-eeddff2`
GIT_COMMIT_SHA ?= $(shell git rev-parse --short=7 HEAD)
GIT_BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
GIT_BRANCH_CLEAN := $(shell echo $(GIT_BRANCH_NAME) | sed "s/[^0-9a-zA-Z_.-]//g")
GIT_TAG ?= $(shell git tag --points-at HEAD | awk '{if ($$0 != "") print "${INTERVIEW_TYPE}."$$0}')
BUILD_IMAGE_TAG := ${INTERVIEW_TYPE}.$(GIT_BRANCH_CLEAN)-$(GIT_COMMIT_SHA)
BUILD_IMAGE_URL := $(BUILD_IMAGE_TAG)
DEPLOY_IMAGE_TAG := $(if $(GIT_TAG),$(GIT_TAG),$(BUILD_IMAGE_TAG))
DEPLOY_IMAGE_URL := $(DEPLOY_IMAGE_TAG)
LATEST_IMAGE_URL := ${INTERVIEW_TYPE}.latest


# Exporting so local docker ymls can pick up the image
export BUILD_IMAGE_URL
export DEPLOY_IMAGE_URL
export LATEST_IMAGE_URL

venv:  ## create Python venv, install poetry, black, pylint, and pytest
	cd $(INTERVIEW_TYPE_DIR) && ${PYTHON3} -m venv venv
	${USE_VENV} pip3 install --upgrade pip


.PHONY: install
install: venv ## install all required packages (will also create venv)
	${USE_VENV} pip3 install --no-cache-dir poetry
	${USE_VENV} poetry install


.PHONY: format
format: venv  ## format all Python code with black
	${USE_VENV} python3 -m black ${SRC_DIR}


.PHONY: lint
lint: venv  ## lint all Python code with pylint
	${USE_VENV} python3 -m pylint ${DIRS_TO_LINT}


.PHONY: test
test: venv  ## run all tests with pytest
	$(USE_VENV) PWD=$(shell pwd) && \
	export PYTHONPATH=$$PWD/interview_tests/$$INTERVIEW_TYPE/src && \
	echo "PYTHONPATH is set to: $$PYTHONPATH" && \
	poetry run pytest ${TEST_DIR}


.PHONY: run
run: venv  ## run dag's scripts
	DEBUG=${DEBUG:-False} ${USE_VENV} python3 src


.PHONY: help
help: ## Display this help screen
	@echo "Usage: make <target>"
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-20s %s\n", $$1, $$2 }' ${MAKEFILE_LIST}
