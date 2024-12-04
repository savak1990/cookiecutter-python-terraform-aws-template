output "api_url" {
  description = "Invoke URL for the API Gateway"
  value       = module.{{ cookiecutter.microservice_name }}.api_url
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.{{ cookiecutter.microservice_name }}.lambda_function_name
}

output "api_gateway_url" {
  description = "Invoke URL for the API Gateway"
  value = module.{{ cookiecutter.microservice_name }}.api_gateway_url
}

output "api_gateway_stage_name" {
  description = "Api Gateway Stage Name that is part of the path when api is invoked"
  value = module.{{ cookiecutter.microservice_name }}.api_gateway_stage_name
}
