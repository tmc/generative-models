# Contains helpful make targets for development
../.venv:
	make -C .. .venv

.PHONY: compile-requirements
compile-requirements: ../.venv ## Compile requirements.in to requirements.txt
	../.venv/bin/pip-compile --verbose requirements.in
	../.venv/bin/pip-compile --verbose requirements-cu118.in

.PHONY: clean
clean: ## Remove the virtual environment
	@rm -rf .venv

.DELETE_ON_ERROR: ## Configure make to delete the target of a rule if it has an error

.PHONY: compile-requirements-docker
compile-requirements-docker: ## Compile requirements.in to requirements.txt (in a docker container)
	# Build the docker image
	docker build --platform=linux/amd64 \
		--build-arg CUDA_DOCKER_VERSION=$(CUDA_DOCKER_VERSION) \
		--target final \
		-t sd-compile-requirements \
		-f ../scripts/Dockerfile.compile-requirements \
		..
	# Run the docker image (to copy the requirements.txt file out)
	docker run --platform=linux/amd64 \
		--gpus all \
		-v $(PWD):/app \
		-t sd-compile-requirements \
		cp /tmp/requirements.txt $(REQUIREMENTS_FILE)

