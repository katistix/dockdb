#!/bin/bash

# Set locale to C to avoid illegal byte sequence errors
LC_ALL=C

# Ask for the database name
read -p "Enter the database name: " dbname

# Generate random username and password
username=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
password=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

# Find an unused port
find_unused_port() {
    while true; do
        port=$(awk -v min=2000 -v max=65000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
        (echo > /dev/tcp/localhost/$port) >/dev/null 2>&1 || return
    done
}

find_unused_port

# Define Docker container name
container_name="postgres_$dbname"

# Start PostgreSQL container with the selected port
docker run --name $container_name -e POSTGRES_USER=$username -e POSTGRES_PASSWORD=$password -e POSTGRES_DB=$dbname -p $port:5432 -d postgres

# Print database URL
echo "PostgreSQL Database URL:"
echo "postgresql://$username:$password@localhost:$port/$dbname"
