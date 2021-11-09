# Starbound server that runs inside a Docker container

**NOTE**: This image will install/update on startup. The path ```/steamcmd/starbound``` can be mounted on the host for data persistence.

# How to run the server
1. Set the environment variables you wish to modify from below (note the Steam credentials)
2. Optionally mount ```/steamcmd/starbound``` somewhere on the host or inside another container to keep your data safe
3. Enjoy!

Be sure to edit `/steamcmd/starbound/storage/starbound_server.config` to customize your server's settings.  
Save files can be found under `/steamcmd/starbound/storage/universe` and mods under `/steamcmd/starbound/mods`.

Note that you can also mount `/app/.steam` to persist logs etc. from `steamcmd`.

The following environment variables are available:
```
STEAM_USERNAME (DEFAULT: "" - Required for installing/updating Starbound)
STEAM_PASSWORD (DEFAULT: "" - Required for installing/updating Starbound)
SKIP_STEAMCMD  (DEFAULT: "" - Optional for skipping updating Starbound)
```

# Steam Guard

If you have Steam Guard enabled, which let's face it: most of us do, you will need to do a few things differently.

1. Run the container with both `-i` (`stdin_open: true` in Compose) and `-t` (`tty: true` in Compose) arguments, which effectively allows for direct interaction
2. Be ready to attach to the container as soon as you launch it, as you will need to relatively quickly be able to provide the authentication code (eg. `docker attach starbound-server`, enter the auth code and detach by pressing `CTRL-p` followed by `CTRL-q`)
3. This should now keep you logged in, at least until the authentication token expires, at which point you can simply do these steps again

NOTE: At some point we may make a less tedious workaround for this, such as a web interface which can be used to securely manage the Steam session, credentials and Steam Guard authentication codes.

# Updating the server

As long as you have both your `STEAM_USERNAME` and `STEAM_PASSWORD` set, simply restarting the container should trigger the update procedure.

# Anything else

If you need help, have questions or bug submissions, feel free to contact me **@Dids** on Twitter.
