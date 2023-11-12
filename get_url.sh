#!/bin/bash

# Function to extract environment variable from container
extract_env_var() {
    docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' $1 | grep $2 | cut -d '=' -f2
}

# Ask for the container name or ID
read -p "Enter the PostgreSQL container name or ID: " container_name

# Extract database information
db_user=$(extract_env_var $container_name "POSTGRES_USER")
db_password=$(extract_env_var $container_name "POSTGRES_PASSWORD")
db_name=$(extract_env_var $container_name "POSTGRES_DB")

# Check if all variables are retrieved
if [ -z "$db_user" ] || [ -z "$db_password" ] || [ -z "$db_name" ]; then
    echo "Error: Could not retrieve database information from the container."
    exit 1
fi

# Construct and print the database URL
echo ""
echo "PostgreSQL Database URL:"
echo ""
echo "postgresql://${db_user}:${db_password}@localhost:5432/${db_name}"
