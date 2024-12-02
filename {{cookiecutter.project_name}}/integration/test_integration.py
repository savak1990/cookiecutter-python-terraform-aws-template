import pytest
import requests
import os

@pytest.fixture
def api_url():
  return os.environ.get(f"{{ cookiecutter.microservice_name }}_API_URL".upper())
  
@pytest.fixture
def env():
  return os.environ.get("ENV", "dev")

@pytest.fixture
def path():
  return "hello"
  
@pytest.fixture
def endpoint(api_url, env, path):
  return f'{api_url}/{env}/{path}'

def test_integration_api_success(endpoint):
  # Make a request to the deployed API Gateway
  response = requests.get(endpoint)

  # Validate the response
  assert response.status_code == 200
  assert response.text == "Hello from {{ cookiecutter.microservice_name }}"

def test_integration_api_missing_name(api_url):
  # Make a request without query parameters
  response = requests.get(api_url)

  # Validate the response
  assert response.status_code == 403
  assert response.text == '{"message":"Forbidden"}'
