#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Create and activate a virtual environment
echo "Creating virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Step 2: Upgrade pip and install initial dependencies
echo "Upgrading pip and installing initial dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Step 3: Run the setup script to generate the project structure
echo "Generating project structure..."
python setup.py -t .

# Step 4: Clean up the setup environment
echo "Cleaning up setup environment..."
deactivate
rm -rf .venv
rm -rf templates
rm -f requirements.txt
rm -f setup.py
rm -f setup.sh

echo "Setup complete!"

