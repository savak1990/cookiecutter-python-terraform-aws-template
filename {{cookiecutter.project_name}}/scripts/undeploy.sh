#!/bin/bash
set -e

# Navigate to the terraform directory
cd deploy

# Deploy Terraform infrastructure
echo "Initializing Terraform..."
terraform init

echo "Applying Terraform configuration..."
terraform destroy -auto-approve

echo "Terraform destroy complete."
