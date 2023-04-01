.DEFAULT_GOAL := build
.PHONY: build pull test

IMAGE_NAME=myimage

#SHELL := /bin/bash

# Returns 0 if image exists, else 1
IMAGE_EXISTS_REMOTE=$(shell docker manifest inspect ${IMAGE_NAME} > /dev/null 2>&1 ; echo $$? )
# Returns 1 if image exists, else 0
IMAGE_EXISTS_LOCALLY=$(shell docker images -q ${IMAGE_NAME} | wc -l )


# Call make docker
pull:
ifeq (${IMAGE_EXISTS_REMOTE},0)
	@echo "\nPulling image ${IMAGE_NAME}\n"
	@docker pull ${IMAGE_NAME}
endif

build: pull
ifeq (${IMAGE_EXISTS_LOCALLY},0)
	@echo "\nBuilding image ${IMAGE_NAME}\n"
	@docker build -t ${IMAGE_NAME} --build-arg YEAR=2023 .
endif

test:
	@echo "Image exisitiert local ${IMAGE_EXISTS_LOCALLY}"
	@echo "Image exisitiert remote ${IMAGE_EXISTS_REMOTE}"
