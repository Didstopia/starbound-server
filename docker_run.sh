#!/bin/bash

./docker_build.sh

# Run a vanilla server
docker run -p 0.0.0.0:21025:21025/tcp --env-file .env -v $(pwd)/starbound_data:/steamcmd/starbound --name starbound-server -d didstopia/starbound-server:latest

docker logs -f starbound-server
