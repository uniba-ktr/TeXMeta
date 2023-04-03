.DEFAULT_GOAL := build
.PHONY: build pull test

dockerimage := myimage

#SHELL := /bin/bash

# Returns 0 if image exists, else 1
IMAGE_EXISTS_REMOTE=$(shell docker manifest inspect ${dockerimage} > /dev/null 2>&1 ; echo $$? )
# Returns 1 if image exists, else 0
IMAGE_EXISTS_LOCALLY=$(shell docker images -q ${dockerimage} | wc -l )
# Get current year
YEAR=$(shell date +%Y)


# Call make docker
pull:
	@echo "\nChecking if image ${dockerimage} exists\n"
ifeq (${IMAGE_EXISTS_REMOTE},0)
	@echo "\nPulling image ${dockerimage}\n"
	@docker pull ${dockerimage}
endif

build: pull
ifeq (${IMAGE_EXISTS_LOCALLY},0)
	@echo "\nBuilding image ${dockerimage}\n"
	@docker build -t ${dockerimage} --build-arg YEAR=${YEAR} .
endif