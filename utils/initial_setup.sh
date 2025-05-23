#!/bin/bash

# Exit on any error
set -e

# Get the directory of this script (utils/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the project root (one level up)
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "Creating virtual environment in $PROJECT_ROOT/.venv ..."
python3 -m venv .venv

echo "Virtual environment created."

echo "Activating virtual environment..."
source .venv/bin/activate

echo "Installing dependencies from requirements.txt..."
pip install -r utils/requirements.txt

echo ""
echo "Setup complete."
echo "To activate the environment later, run: source .venv/bin/activate"
