import logging
import os

logger = logging.getLogger()
log_level = os.getenv("LOG_LEVEL", "INFO").upper()
logger.setLevel(log_level)

def handler(event, context):
  logger.info(f"Lambda function invoked: log_level={log_level}")
  logger.debug(f"Event: {event}")
  
  logger.info("Processing event successfully.")
  return {
    'statusCode': 200,
    'body': 'Hello from {{ cookiecutter.microservice_name }}'
  }
