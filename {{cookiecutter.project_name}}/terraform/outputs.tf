output "{{ cookiecutter.microservice_name }}_api_url" {
  description = "Invoke URL for the {{ cookiecutter.microservice_name }} API Gateway"
  value       = module.{{ cookiecutter.microservice_name }}_api_gateway.api_url
}

output "{{ cookiecutter.microservice_name }}_lambda_function_name" {
  description = "Name of the deployed Lambda function for {{ cookiecutter.microservice_name }}"
  value       = module.{{ cookiecutter.microservice_name }}_lambda.lambda_function_name
}
