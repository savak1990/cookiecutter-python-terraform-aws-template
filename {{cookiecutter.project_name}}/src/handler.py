from serverless_wsgi import handle_request
from app import create_app
import logging
import os

app = create_app()

logger = logging.getLogger()
log_level = os.getenv("LOG_LEVEL", "INFO").upper()
logger.setLevel(log_level)

def handler(event, context):
    return handle_request(app, event, context)