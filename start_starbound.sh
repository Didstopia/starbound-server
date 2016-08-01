#!/usr/bin/env bash

# Define the exit handler
exit_handler()
{
	echo "Shutdown signal received"
	kill -SIGINT "$child"
}

# Trap specific signals and forward to the exit handler
trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

# Create the necessary folder structure
if [ ! -d "/steamcmd/starbound/linux" ]; then
	echo "Creating folder structure.."
	mkdir -p /steamcmd/starbound/linux
fi

# Install/update steamcmd
echo "Installing/updating steamcmd.."
curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /steamcmd -zx

# Check that username and password are both set
if [ ! -z "$STEAM_USERNAME" ] || [ ! -z "$STEAM_PASSWORD" ]; then
	# Setup username/password for Steam
	sed -i "s/login anonymous/login $STEAM_USERNAME $STEAM_PASSWORD/g" /install.txt
fi

# Check that Starbound exists in the first place
if [ ! -f "/steamcmd/starbound/linux/starbound_server" ]; then
	# Check that username and password are both set, otherwise quit with error
	if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
		echo "Error: you must set both your Steam username and password to install the server"
		exit 1
	fi
	# Install Starbound from install.txt
	echo "Installing/updating Starbound.."
	bash /steamcmd/steamcmd.sh +runscript /install.txt
else
	# Check that username and password are both set, otherwise skip update
	if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
		echo "Steam username or password not set, skipping update.."
		exit 1
	else
		# Install Starbound from install.txt
		echo "Installing Starbound.."
		bash /steamcmd/steamcmd.sh +runscript /install.txt
	fi
fi

# Set the working directory
cd /steamcmd/starbound/linux

# Run the server
echo "Starting Starbound.."
./starbound_server 2>&1 &

child=$!
wait "$child"
