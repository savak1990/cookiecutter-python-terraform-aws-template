from flask import Flask, jsonify, request
import logging

def create_app():
    app = Flask(__name__)

    @app.route("/info", methods=["GET"])
    def info():
        logging.debug(f"/info is invoked")
        return jsonify({"info": "This is the /info endpoint."})

    @app.route("/health", methods=["GET"])
    def health():
        logging.debug(f"/health is invoked")
        return jsonify({"status": "healthy"})

    @app.route("/hello", methods=["GET"])
    def hello():
        """Returns health status."""
        logging.debug(f"/hello is invoked")
        return jsonify({"message": "Hello from {{ cookiecutter.microservice_name }}"})
    
    return app