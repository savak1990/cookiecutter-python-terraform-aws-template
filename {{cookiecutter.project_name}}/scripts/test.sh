#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Define the virtual environment directory
VENV_DIR=".venv"

# Define the source and test directories
SRC_DIR="./src"
TEST_DIR=$1
echo "Test dir: $TEST_DIR"

# Create the virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in $VENV_DIR..."
    python3 -m venv $VENV_DIR
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source $VENV_DIR/bin/activate

# Upgrade pip and install project dependencies
echo "Upgrading pip..."
pip install --upgrade pip

# Add src/ to PYTHONPATH
export PYTHONPATH=$SRC_DIR:$PYTHONPATH

# Installing test dependencies
echo "Installing test dependencies..."
pip install -r $TEST_DIR/requirements.txt

# Package Lambda function (list only directories)
echo "Installing {{ cookiecutter.microservice_name }} dependencies and creating a module..."
pip install -r "$SRC_DIR/requirements.txt"
pip install -e "$SRC_DIR"

# Run the tests
echo "Running tests..."
pytest $TEST_DIR

echo "All tests passed!"

# Deactivate the virtual environment (optional)
echo "Deactivating virtual environment..."
deactivate
