# Contains helpful make targets for development
REQUIREMENTS_FILE?=requirements.txt
ifeq ($(UNAME_S), Darwin)
	REQUIREMENTS_FILE=requirements-macos.txt
endif

.venv: requirements/$(REQUIREMENTS_FILE) ## Create a virtual environment and install dependencies
	python3 -m venv --clear .venv
	.venv/bin/pip install wheel pip-tools
	.venv/bin/pip install -r requirements/$(REQUIREMENTS_FILE)
	.venv/bin/pip install .

.PHONY: test
test: test-inference ## Run tests

.PHONY: test-inference
test-inference: .venv ## Run inference tests
	.venv/bin/pip install -e git+https://github.com/Stability-AI/datapipelines.git@main#egg=sdata
	.venv/bin/pytest -v tests/inference/test_inference.py

.PHONY: test-inference-docker
test-inference-docker: ## Run inference tests (in a docker container)
	# Build the docker image
	docker build --platform=linux/amd64 \
		--build-arg CUDA_DOCKER_VERSION=$(CUDA_DOCKER_VERSION) \
		--target test-inference \
		-t sd-test-inference \
		-f scripts/Dockerfile.compile-requirements \
		.
	# Run the docker image
	docker run --platform=linux/amd64 \
		-v $(PWD):/app \
		-t sd-test-inference

.PHONY: clean
clean: ## Remove the virtual environment
	@rm -rf .venv

.DELETE_ON_ERROR: ## Configure make to delete the target of a rule if it has an error

