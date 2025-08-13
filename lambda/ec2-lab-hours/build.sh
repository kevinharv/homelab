#!/bin/bash
set -e

LAMBDA_DIR=$(dirname "$0")
cd "$LAMBDA_DIR"

echo "Installing dependencies..."
rm -rf package
mkdir -p package
pip install -r requirements.txt -t package/

echo "Zipping function..."
cd package
zip -r ../function.zip src/
