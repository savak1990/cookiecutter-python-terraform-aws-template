def handler(event, context):
  return {
    'statusCode': 200,
    'body': 'Hello from {{ cookiecutter.microservice_name }}'
  }
