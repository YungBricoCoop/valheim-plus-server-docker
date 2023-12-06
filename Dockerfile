FROM ubuntu:22.04

# Define environment variables
ENV STEAMCMD_DIR /usr/games/steamcmd
ENV VALHEIM_DIR /opt/valheim
ENV VALHEIM_WORLD /home/valheim/.config/unity3d/IronGate/Valheim
ENV VALHEIM_CONFIG $VALHEIM_DIR/BepInEx/config
ENV VALHEIM_PLUS_URL https://github.com/Grantapher/ValheimPlus/releases/download/0.9.12.0-alpha01/UnixServer.tar.gz

# Server environment variables
ENV SERVER_NAME "Docker Valheim Server"
ENV SERVER_PORT 2456
ENV WORLD_NAME "Dedicated"
ENV SERVER_PASSWORD "Odin#0202"

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
	&& echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
	&& apt-get update -y \
	&& apt-get install -y --no-install-recommends ca-certificates locales steamcmd wget file \
	&& rm -rf /var/lib/apt/lists/ \
	&& ln -s $STEAMCMD_DIR /usr/bin/steamcmd

# Update SteamCMD and verify latest version
RUN steamcmd +quit

# Install Valheim Server
RUN mkdir -p $VALHEIM_DIR \
	&& steamcmd +login anonymous +force_install_dir $VALHEIM_DIR +app_update 896660 validate +quit

# Install Valheim Plus
RUN wget $VALHEIM_PLUS_URL -O /tmp/valheim_plus.tar.gz \
	&& tar -xzf /tmp/valheim_plus.tar.gz -C $VALHEIM_DIR \
	&& chmod +x $VALHEIM_DIR/start_server_bepinex.sh \
	&& sed -i 's|exec ./valheim_server.x86_64 -name "My server" -port 2456 -world "Dedicated" -password "secret"|exec ./valheim_server.x86_64 -name "$SERVER_NAME" -port $SERVER_PORT -world "$WORLD_NAME" -password "$SERVER_PASSWORD"|' $VALHEIM_DIR/start_server_bepinex.sh

# Create user and group for Valheim
RUN groupadd -r valheim && useradd -r -m -g valheim valheim

# Set directory permissions
RUN chown -R valheim:valheim $VALHEIM_DIR

# Ports required for Valheim
EXPOSE 2456-2458/udp

# Volume for persistence
VOLUME ${VALHEIM_WORLD}
VOLUME ${VALHEIM_DIR}

# Switch to valheim user
USER valheim

# Command to run
CMD ["/bin/bash", "-c", "cd $VALHEIM_DIR && ./start_server_bepinex.sh"]