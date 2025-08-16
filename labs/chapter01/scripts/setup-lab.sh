# /labs/chapter01/scripts/setup-lab.sh
#!/bin/bash
# Setup script for Chapter 1 lab environment

echo "Setting up Chapter 1 Secure Hello World Lab..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "PostgreSQL is required but not installed. Please install PostgreSQL first."
    exit 1
fi

# Create database and setup
echo "Creating secure database..."
psql -U postgres -f setup/hello-world-database.sql

# Install Python dependencies
echo "Installing Python dependencies..."
pip install psycopg2-binary

echo "Lab setup complete!"
echo "Run: python python/secure_hello_app.py to test the secure implementation"
