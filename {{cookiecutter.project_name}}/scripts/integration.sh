#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Navigate to the terraform directory
cd deploy

# Get the Terraform output api gateway url. Don't use the final URL from Route 53 because it takes time to setup
# while with api gateway you can start testing right away.
{{ cookiecutter.microservice_name|upper }}_API_URL=$(terraform output -raw api_gateway_url)

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
