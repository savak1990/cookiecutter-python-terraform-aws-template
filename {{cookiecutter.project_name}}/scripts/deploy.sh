#!/bin/bash
set -e

# Navigate to the terraform directory
cd terraform

# Deploy Terraform infrastructure
echo "Initializing Terraform..."
terraform init

echo "Applying Terraform configuration..."
terraform apply -auto-approve

echo "Terraform deployment complete."
