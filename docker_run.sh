#!/bin/bash

# Build changes (if necessary)
./docker_build.sh

# Run a container
docker run -p 0.0.0.0:21025:21025/tcp --env-file .env -v "$(pwd)/starbound_data:/steamcmd/starbound" --name starbound-server -it --rm didstopia/starbound-server:latest

# Edit unit tests
#dgoss edit -p 0.0.0.0:21025:21025/tcp --env-file .env -v "$(pwd)/starbound_data:/steamcmd/starbound" --name starbound-server -d didstopia/starbound-server:latest

# Run unit tests (production)
#GOSS_WAIT_OPTS="--retry-timeout 300s --sleep 1s > /dev/null" GOSS_SLEEP="15" dgoss run -p 0.0.0.0:21025:21025/tcp --env-file .env -v "$(pwd)/starbound_data:/steamcmd/starbound" --name starbound-server -d didstopia/starbound-server
