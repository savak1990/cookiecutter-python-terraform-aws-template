# Define variables
VENV_DIR := .venv
SRC_DIR := src
TEST_DIR := tests
INTEG_DIR := integration
TERRAFORM_DIR := terraform
DEPLOY_DIR := deploy
REQUIREMENTS := $(SRC_DIR)/requirements.txt
TEST_REQUIREMENTS := $(TEST_DIR)/requirements.txt
INTEG_TEST_REQUIREMENTS := $(INTEG_DIR)/requirements.txt
BUILD_DIR = build
MICROSERVICE_NAME = {{ cookiecutter.microservice_name }}
ZIP_PACKAGE_FILE = $(BUILD_DIR)/$(MICROSERVICE_NAME).zip
TEMP_SERVICE_DIR = $(BUILD_DIR)/$(MICROSERVICE_NAME)
PACKAGE_TIMESTAMP_FILE := $(BUILD_DIR)/.package.timestamp
API_URL_FILE := $(BUILD_DIR)/api_url.txt

PIP = $(VENV_DIR)/bin/pip
PYTEST = $(VENV_DIR)/bin/pytest

# Find all .py and .txt files in the src directory
SRC_FILES := $(shell find $(SRC_DIR) -type f \( -name "*.py" -o -name "*.txt" \))
TF_FILES := $(shell find $(TERRAFORM_DIR) $(DEPLOY_DIR) -type f -name "*.tf")

# Targets
.PHONY: all build package deploy destroy test integration clean 

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
	terraform apply -auto-approve && \
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
	terraform destroy -auto-approve

# Clean up build artifacts
clean:
	@echo "Cleaning up build directory..."
	rm -rf $(BUILD_DIR)
	rm -rf $(VENV_DIR)
	@echo "Build artifacts cleaned"

# Full workflow: package, test, deploy
all: clean test integration
