#!/bin/bash
set -e

# Define paths
SRC_DIR="./src"
BUILD_DIR="./build"
VENV_DIR=".venv"

# Create build directory
mkdir -p $BUILD_DIR

# Create and activate a virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $VENV_DIR
fi

echo "Activating virtual environment..."
source $VENV_DIR/bin/activate

# Upgrade pip in the virtual environment
echo "Upgrading pip..."
pip install --upgrade pip

# Package each Lambda function
for SERVICE in $(ls $SRC_DIR); do
    echo "Packaging $SERVICE..."

    SERVICE_DIR="$SRC_DIR/$SERVICE"
    TEMP_SERVICE_DIR="$BUILD_DIR/$SERVICE"

    # Clean up any previous temp_package directory
    rm -rf $TEMP_SERVICE_DIR

    # Check if requirements.txt exists and install dependencies
    if [ -f "$SERVICE_DIR/requirements.txt" ]; then
        echo "Installing dependencies for $SERVICE..."
        mkdir -p $TEMP_SERVICE_DIR
        pip install -r $SERVICE_DIR/requirements.txt --target $TEMP_SERVICE_DIR
    fi

    # Copy source files into temp_package
    cp -r $SERVICE_DIR/* $TEMP_SERVICE_DIR

    # Remove unnecessary files from the temp_package directory
    rm -rf $TEMP_SERVICE_DIR/__pycache__

    # Create a zip package
    cd $TEMP_SERVICE_DIR
    zip -r ../${SERVICE}.zip . -x "*.pyc" -x "__pycache__/*"
    cd - > /dev/null

    echo "$SERVICE packaged successfully!"
done

# Deactivate the virtual environment (optional)
echo "Deactivating virtual environment..."
deactivate

echo "Packaging complete. Files are in $BUILD_DIR."
