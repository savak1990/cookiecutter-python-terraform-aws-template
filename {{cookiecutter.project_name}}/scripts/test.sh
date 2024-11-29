#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Define the virtual environment directory
VENV_DIR=".venv"

# Define the source and test directories
SRC_DIR="./src"
TEST_DIR="./tests"

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

for SERVICE_TEST in $(find "$TEST_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;); do
  echo "Installing $SERVICE_TEST dependencies..."
  pip install -r $TEST_DIR/$SERVICE_TEST/requirements.txt
done

# Package each Lambda function (list only directories)
for SERVICE in $(find "$SRC_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;); do
  echo "Installing $SERVICE dependencies and creating a module..."
  pip install -r "$SRC_DIR/$SERVICE/requirements.txt"
  pip install -e "$SRC_DIR/$SERVICE"
done

# Run the tests
echo "Running tests..."
pytest $TEST_DIR

echo "All tests passed!"

# Deactivate the virtual environment (optional)
echo "Deactivating virtual environment..."
deactivate
