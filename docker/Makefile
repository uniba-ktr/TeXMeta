.DEFAULT_GOAL := build
.PHONY: build pull

dockerimage := "ghcr.io/uniba-ktr/texmeta"

# Returns 0 if image exists, else 1
IMAGE_EXISTS_REMOTE := $(shell docker manifest inspect ${dockerimage} > /dev/null 2>&1; echo $$? )
# Returns 1 if image exists, else 0
IMAGE_EXISTS_LOCALLY := $(shell docker images -q ${dockerimage} | wc -l )
# Get current year
YEAR=$(shell date +%Y)

# Call make docker
pull:
ifeq (${IMAGE_EXISTS_REMOTE},0)
	@echo "\nPulling image ${dockerimage}\n"
	@docker pull ${dockerimage}
	@export IMAGE_EXISTS_LOCALLY=1
endif

build: pull
ifeq (${IMAGE_EXISTS_LOCALLY},0)
	@echo "\nBuilding image ${dockerimage}\n"
	@docker build -t ${dockerimage} --build-arg YEAR=${YEAR} .
endif
