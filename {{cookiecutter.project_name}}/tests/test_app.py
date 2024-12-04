import pytest
from src.app import create_app

@pytest.fixture
def app():
  """Create and configure a new app instance for each test."""
  app = create_app()
  app.config.update({
    "TESTING": True,  # Enable testing mode
    "DEBUG": False    # Disable debug mode
  })
  return app

@pytest.fixture
def client(app):
  """Create a test client for the app."""
  return app.test_client()

def test_hello_endpoint(client):
  """Test the /hello endpoint."""
  response = client.get('/hello')
  assert response.status_code == 200
  assert response.get_json() == {'message': 'Hello from {{ cookiecutter.microservice_name }}'}

def test_info_endpoint(client):
  """Test the /info endpoint."""
  response = client.get('/info')
  assert response.status_code == 200
  assert response.get_json() == {'info': 'This is the /info endpoint.'}

def test_health_endpoint(client):
  """Test the /health endpoint."""
  response = client.get('/health')
  assert response.status_code == 200
  assert response.get_json() == {'status': 'healthy'}
  