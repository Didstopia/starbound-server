#!/usr/bin/env bash

# Define the exit handler
exit_handler()
{
	echo ""
	echo "Waiting for server to shutdown.."
	echo ""
	kill -SIGINT "$child"
	sleep 5

	echo ""
	echo "Terminating.."
	echo ""
	exit
}

# Trap specific signals and forward to the exit handler
trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

# Create the necessary folder structure
if [ ! -d "/steamcmd/starbound/linux" ]; then
	echo "Creating folder structure.."
	mkdir -p /steamcmd/starbound/linux
fi

# Install/update steamcmd
echo ""
echo "Installing/updating steamcmd.."
echo ""
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
	echo ""
	echo "Installing Starbound.."
	echo ""
	bash /steamcmd/steamcmd.sh +runscript /install.txt
else
	# Check that username and password are both set, otherwise skip update
	if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
		if [ -z "$SKIP_STEAMCMD" ]; then
			echo "Steam username or password not set, exiting.."
			exit 1
		else
			echo "Steam username or password not set, skipping update.."
		fi
	else
		# Install Starbound from install.txt
		echo ""
		echo "Updating Starbound.."
		echo ""
		bash /steamcmd/steamcmd.sh +runscript /install.txt
	fi
fi

# Set the working directory
cd /steamcmd/starbound/linux || exit

# Copy default configuration if necessary
if [ ! -f "/steamcmd/starbound/storage/starbound_server.config" ]; then
	echo ""
	echo "Copying default configuration.."
	echo ""
	mkdir -p /steamcmd/starbound/storage
	cp -f /starbound_server.default.config /steamcmd/starbound/storage/starbound_server.config
fi

# Run the server
echo ""
echo "Starting Starbound.."
echo ""
./starbound_server 2>&1 &

child=$!
wait "$child"
