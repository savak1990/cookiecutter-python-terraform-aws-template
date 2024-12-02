# Define variables
BUILD_DIR = ./build
SRC_DIR = ./src

# Targets
.PHONY: all package deploy destroy test clean

# Build and package Lambda functions
package:
	bash scripts/package_lambdas.sh

# Deploy infrastructure and Lambda functions
deploy: package
	bash scripts/deploy.sh

# Destroy infrastructure
undeploy:
	bash scripts/undeploy.sh

# Run tests
test:
	bash scripts/test.sh ./tests

# Run integration tests
integration: deploy
	bash scripts/integration.sh

# Clean up build artifacts
clean: undeploy
	bash scripts/clean.sh

# Full workflow: package, test, deploy
all: clean package test deploy
