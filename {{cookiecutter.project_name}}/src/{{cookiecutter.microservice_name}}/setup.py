from setuptools import setup, find_packages

setup(
  name="{{ cookiecutter.microservice_name }}",
  version="0.1.0",
  packages=find_packages(),
  package_dir={"": "."}, 
)