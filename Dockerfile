FROM didstopia/base:nodejs-steamcmd-ubuntu-16.04

MAINTAINER Didstopia <support@didstopia.com>

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    net-tools && \
	rm -rf /var/lib/apt/lists/*

# Create and set the steamcmd folder as a volume
RUN mkdir -p /steamcmd/starbound
VOLUME ["/steamcmd/starbound"]

# Add the steamcmd installation script
ADD install.txt /install.txt

# Copy the startup script
ADD start_starbound.sh /start.sh

# Copy the default configuration file
ADD starbound_server.default.config /starbound_server.default.config

# Set the current working directory
WORKDIR /

# Expose necessary ports
EXPOSE 21025/tcp

# Setup default environment variables for the server
ENV STEAM_USERNAME ""
ENV STEAM_PASSWORD ""

# Start the server
ENTRYPOINT ["./start.sh"]
