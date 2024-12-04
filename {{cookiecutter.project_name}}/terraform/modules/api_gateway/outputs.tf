output "default_url" {
  description = "Invoke URL of the API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}

output "custom_domain_name" {
  value = "https://${aws_route53_record.api_record.name}"
}

output "stage_name" {
  value = local.stage_name
}
