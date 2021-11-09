#!/usr/bin/env bash

# Enable debugging
# set -x

# Setup error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialised variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

# Print the user we're currently running as
echo "Running as user: $(whoami)"

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

# Define the install/update function
install_or_update()
{
	# Install Starbound from install.txt
	echo "Installing or updating Starbound.. (this might take a while, be patient)"
  steamcmd +runscript /app/install.txt

	# Terminate if exit code wasn't zero
	if [ $? -ne 0 ]; then
		echo "Exiting, steamcmd install or update failed!"
		exit 1
	fi
}

# Check that username and password are both set
if [ ! -z "$STEAM_USERNAME" ] && [ ! -z "$STEAM_PASSWORD" ]; then
	# Setup username/password for Steam
	sed -i "s/login anonymous/login $STEAM_USERNAME $STEAM_PASSWORD/g" /app/install.txt

  ## FIXME: If we do this, then the installation will prompt us again for the Auth Code, not sure why?!
  # # Attempt to login
  # steamcmd +login $STEAM_USERNAME $STEAM_PASSWORD +quit
else
  echo "Missing STEAM_USERNAME and/or STEAM_PASSWORD, unable to continue!"
  exit 1
fi

# Create the necessary folder structure
if [ ! -d "/steamcmd/starbound" ]; then
	echo "Missing /steamcmd/starbound, creating.."
	mkdir -p /steamcmd/starbound
fi

# Check that Starbound exists in the first place
if [ ! -f "/steamcmd/starbound/linux/starbound_server" ]; then
	# Install or update Starbound
  install_or_update
else
	# Check if we should skip updates
	if [ ! -z "$SKIP_STEAMCMD" ]; then
    echo "Skip steamcmd set, skipping update checks.."
	else
		# Install or update Starbound
    install_or_update
	fi
fi

# Set the working directory
cd /steamcmd/starbound/linux || exit 1

# Run the server
echo ""
echo "Starting Starbound.."
echo ""
/steamcmd/starbound/linux/starbound_server 2>&1 &

# Get the PID of the server
child=$!

# Wait until the server stops
wait "$child"
