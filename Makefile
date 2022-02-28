include ./Makefile.ci

BUILD_TAG ?= $(shell git rev-parse --short HEAD)
DOCKER_REGISTRY := gcr.io/oursky-kube
DOCKER_IMAGE := ${DOCKER_REGISTRY}/likecoin-faucet:${BUILD_TAG}
ARCH := $(shell uname -m)

ifeq ($(ARCH), arm64)
DOCKER_OPT ?= --platform=linux/amd64
endif

.PHONY: setup
setup: vendor
	cp .env.example .env

.PHONY: vendor
vendor:
	yarn install

.PHONY: lint
lint:
	yarn lint

.PHONY: format
format:
	yarn format

.PHONY: ci
ci:
	yarn test

.PHONY: docker-build
docker-build:
	docker build ${DOCKER_OPT} -t ${DOCKER_IMAGE} .

.PHONY: docker-push
docker-push:
	docker push ${DOCKER_IMAGE}

.PHONY: docker-pull
docker-pull:
	docker pull ${DOCKER_IMAGE}
