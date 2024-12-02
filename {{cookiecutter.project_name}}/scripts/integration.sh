#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Navigate to the terraform directory
cd terraform

# Get the Terraform output
{{ cookiecutter.microservice_name|upper }}_API_URL=$(terraform output -raw {{ cookiecutter.microservice_name }}_api_url)

# Check if Terraform output was successful
if [ -z "${{ cookiecutter.microservice_name|upper }}_API_URL" ]; then
    echo "Error: Could not retrieve '{{ cookiecutter.microservice_name }}_api_url' from Terraform output."
    exit 1
fi

# Export the variable
export {{ cookiecutter.microservice_name|upper }}_API_URL

# Navigate back to the original directory
cd - > /dev/null || exit 1

# Pass the argument(s) to test.sh
bash ./scripts/test.sh "./integration"
