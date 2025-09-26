#!/bin/sh

# This tells the script to exit immediately if a command fails
set -e

# Run the database migrations
echo "Running database migrations..."
flask db upgrade

# Execute the command passed to the script (our Gunicorn CMD)
exec "$@"
