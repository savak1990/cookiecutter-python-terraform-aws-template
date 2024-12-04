import pytest
import requests
import os

@pytest.fixture
def api_url():
  host = os.environ.get("API_URL")
  stage_name = os.environ.get("API_STAGE_NAME")
  return f'{host}{stage_name}'

@pytest.fixture
def path():
  return "hello"
  
@pytest.fixture
def endpoint(api_url, path):
  return f'{api_url}/{path}'

def test_integration_api_success(endpoint):
  # Make a request to the deployed API Gateway
  response = requests.get(endpoint)

  # Validate the response
  assert response.status_code == 200
  
  # Ensure the response is JSON
  try:
    json_data = response.json()
  except ValueError:
    assert False, "Response is not valid JSON"
  
  expected_json = {
    "message": "Hello from {{ cookiecutter.microservice_name }}"
  }
  
  assert json_data == expected_json, f"Unexpected json response"

def test_integration_api_missing_name(api_url):
  # Make a request without query parameters
  response = requests.get(api_url)

  # Validate the response
  assert response.status_code == 403
