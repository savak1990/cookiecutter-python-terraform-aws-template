import pytest
from src.{{cookiecutter.microservice_name}}.handler import handler

def test_lambda_handler_success():
  # Mock event and context
  event = {}
  context = {}

  # Call the Lambda function
  response = handler(event, context)

  # Validate the response
  assert response["statusCode"] == 200
  assert response["body"] == 'Hello from {{ cookiecutter.microservice_name }}'
