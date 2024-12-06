# Define variables
MICROSERVICE_NAME = {{ cookiecutter.microservice_name }}

VENV_DIR := .venv
SRC_DIR := src
TEST_DIR := tests
INTEG_DIR := integration
TERRAFORM_DIR := terraform
DEPLOY_DIR := deploy
BUILD_DIR = build

REQUIREMENTS := $(SRC_DIR)/requirements.txt
TEST_REQUIREMENTS := $(TEST_DIR)/requirements.txt
INTEG_TEST_REQUIREMENTS := $(INTEG_DIR)/requirements.txt

ZIP_PACKAGE_FILE = $(BUILD_DIR)/$(MICROSERVICE_NAME).zip
TEMP_SERVICE_DIR = $(BUILD_DIR)/$(MICROSERVICE_NAME)
PACKAGE_TIMESTAMP_FILE := $(BUILD_DIR)/.package.timestamp
API_URL_FILE := $(BUILD_DIR)/api_url.txt
ROOT_BUCKET := {{ cookiecutter.artifacts_storage }}
INSTANCE_NAME := $$(whoami)
GITHUB_OWNER := {{ cookiecutter.github_owner }}
GITHUB_PROJECT_NAME := {{ cookiecutter.github_project_name }}
GITHUB_REPO := $(GITHUB_OWNER)/$(GITHUB_PROJECT_NAME)
GITHUB_TOKEN_AWS_SECRET := {{ cookiecutter.github_token_aws_secret }}

PIP = $(VENV_DIR)/bin/pip
PYTEST = $(VENV_DIR)/bin/pytest

# Find all .py and .txt files in the src directory
SRC_FILES := $(shell find $(SRC_DIR) -type f \( -name "*.py" -o -name "*.txt" \))
TF_FILES := $(shell find $(TERRAFORM_DIR) $(DEPLOY_DIR) -type f -name "*.tf")

# Targets
.PHONY: all build package deploy destroy test integration clean pipeline kill-pipeline github kill-github

# Target to create virtual environment and install requirements
$(VENV_DIR): $(REQUIREMENTS)
	@echo "Building virtual environment..."
	rm -rf $(VENV_DIR)
	python3 -m venv $(VENV_DIR)
	$(PIP) install --upgrade pip
	$(PIP) install -r $(REQUIREMENTS)
	@echo "Virtual environment setup complete."

# Build target
build: $(VENV_DIR)
	@echo "Build complete and dependencies installed. Up-to-date: $(VENV_DIR)"

# Create an archive only if necessary
$(PACKAGE_TIMESTAMP_FILE): $(SRC_FILES) $(VENV_DIR) $(REQUIREMENTS)
	@echo "Packaging zip file: $(ZIP_PACKAGE_FILE)"
	rm -rf $(TEMP_SERVICE_DIR)
	mkdir -p $(TEMP_SERVICE_DIR)
	$(PIP) install -r $(REQUIREMENTS) --target $(TEMP_SERVICE_DIR)
	cp -r $(SRC_DIR)/* $(TEMP_SERVICE_DIR)
	cd $(TEMP_SERVICE_DIR) && \
	zip -X -r ../$(MICROSERVICE_NAME).zip . -x "*.pyc" -x "__pycache__/*"
	touch $(PACKAGE_TIMESTAMP_FILE)
	@echo "Zip file created at: $(ZIP_PACKAGE_FILE)"

# Ensure package runs the zip logic only if needed
package: $(PACKAGE_TIMESTAMP_FILE)
	@echo "Packaging logic completed. Up-to-date: $(ZIP_PACKAGE_FILE)"

# Run tests
test: $(VENV_DIR) $(TEST_REQUIREMENTS)
	@echo "Running tests..."
	$(PIP) install -r $(TEST_REQUIREMENTS)
	$(PIP) install -e $(SRC_DIR)
	@PYTHONPATH=$(SRC_DIR):$(PYTHONPATH) $(PYTEST) $(TEST_DIR)
	@echo "All tests passed!"

# Run integration tests
integration: $(VENV_DIR) $(INTEG_TEST_REQUIREMENTS)
	@echo "Running integration tests..."
	$(PIP) install -r $(INTEG_TEST_REQUIREMENTS)
	@API_URL=$$(cd deploy && terraform output --raw api_gateway_url) API_STAGE_NAME=$$(cd deploy && terraform output --raw api_gateway_stage_name) $(PYTEST) integration

$(API_URL_FILE): $(PACKAGE_TIMESTAMP_FILE) $(TF_FILES)
	@echo "Deploying terraform module..."
	rm -f $(API_URL_FILE)
	cd deploy && \
	terraform init && \
	terraform apply -auto-approve -var="instance_name=$(INSTANCE_NAME)" && \
	terraform output --raw api_url > ../$(API_URL_FILE)

# Deploy infrastructure and Lambda functions
deploy: $(API_URL_FILE)
	@echo "Deployment completed. Up-to-date: $$(cat $(API_URL_FILE))"

# Destroy infrastructure
undeploy:
	@echo "Removing deployment..."
	rm -f $(API_URL_FILE)
	cd deploy && \
	terraform init && \
	terraform destroy -auto-approve -var="instance_name=$(INSTANCE_NAME)"

# Clean up build artifacts
clean:
	@echo "Cleaning up build directory..."
	rm -rf $(BUILD_DIR)
	rm -rf $(VENV_DIR)
	@echo "Build artifacts cleaned"

# Creates github repository
github:
	@echo "Creating github repository for the project..."
	cd github && terraform init
	cd github && terraform apply -auto-approve \
		-var="github_token_aws_secret=$(GITHUB_TOKEN_AWS_SECRET)" \
		-var="github_owner=$(GITHUB_OWNER)" \
		-var="github_repo_name=$(GITHUB_PROJECT_NAME)"
	git init
	git add .
	git commit -m "Initial commit"

# Kills github repository
kill-github:
	@echo "Deleting github repository for the project..."
	cd github && terraform init
	cd github && terraform destroy \
		-var="github_token_aws_secret=$(GITHUB_TOKEN_AWS_SECRET)" \
		-var="github_owner=$(GITHUB_OWNER)" \
		-var="github_repo_name=$(GITHUB_PROJECT_NAME)"

# Creates AWS Code Pipeline for this project
pipeline:
	@echo "Creating pipeline for the project..."
	cd pipeline && terraform init
	cd pipeline && terraform apply -auto-approve

# Kills aws pipeline for this project
kill-pipeline:
	@echo "Deleting pipeline for the project..."
	aws s3 rm s3://$(ROOT_BUCKET)/$(MICROSERVICE_NAME) --recursive
	cd pipeline && terraform init
	cd pipeline && terraform destroy -auto-approve

# Full workflow: package, test, deploy
all: clean test integration
