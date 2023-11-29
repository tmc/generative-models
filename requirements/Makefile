# Contains helpful make targets for development
UNAME_S?=$(shell uname -s)
REQUIREMENTS_FILE?=requirements.txt
CUDA_DOCKER_VERSION?=11.8.0
ifeq ($(UNAME_S), Darwin)
	REQUIREMENTS_FILE=requirements-macos.txt
endif

../.venv:
	make -C .. .venv

.PHONY: compile-requirements
compile-requirements: ../.venv ## Compile requirements.in to requirements.txt
	../.venv/bin/pip-compile requirements.in --output-file=$(REQUIREMENTS_FILE)

.PHONY: compile-requirements-docker
compile-requirements-docker: ## Compile requirements.in to requirements.txt (in a docker container)
	# Build the docker image
	docker build --platform=linux/amd64 \
		--build-arg CUDA_DOCKER_VERSION=$(CUDA_DOCKER_VERSION) \
		--target final \
		-t sd-compile-requirements \
		-f ../scripts/Dockerfile.compile-requirements \
		.
	# Run the docker image (to copy the requirements.txt file out)
	docker run --platform=linux/amd64 \
		--gpus all \
		-v $(PWD):/app \
		-t sd-compile-requirements \
		cp /tmp/requirements.txt $(REQUIREMENTS_FILE)

.PHONY: clean
clean: ## Remove the virtual environment
	@rm -rf .venv

.DELETE_ON_ERROR: ## Configure make to delete the target of a rule if it has an error

