FROM didstopia/base:steamcmd-ubuntu-20.04

LABEL maintainer="Didstopia <support@didstopia.com>"

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Create the volume directories
RUN mkdir -p /steamcmd/starbound

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy the startup script
ADD start.sh /app/start.sh

# Set the current working directory
WORKDIR /

# Fix permissions
RUN chown -R 1000:1000 \
    /steamcmd \
    /app

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 21025/tcp

# Setup default environment variables for the server
ENV STEAM_USERNAME ""
ENV STEAM_PASSWORD ""
ENV SKIP_STEAMCMD ""

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

# Expose the volumes
VOLUME [ "/app.steam", "/steamcmd/starbound" ]

# Start the server
CMD [ "bash", "/app/start.sh"]
