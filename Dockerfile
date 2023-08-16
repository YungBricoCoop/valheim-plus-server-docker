FROM ubuntu:22.04

# Define environment variables
ENV STEAMCMD_DIR /usr/games/steamcmd
ENV VALHEIM_DIR /opt/valheim
ENV VALHEIM_SAVE /opt/valheim_save
#ENV ENV VALHEIM_PLUS_URL https://github.com/valheimPlus/ValheimPlus/releases/download/0.9.9.11/UnixServer.tar.gz # Official release
ENV VALHEIM_PLUS_URL https://github.com/Grantapher/ValheimPlus/releases/download/0.9.9.16/UnixServer.tar.gz

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
	&& echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
	&& apt-get update -y \
	&& apt-get install -y --no-install-recommends ca-certificates locales steamcmd wget file \
	&& rm -rf /var/lib/apt/lists/
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Update SteamCMD and verify latest version
RUN steamcmd +quit

# Install Valheim Server
RUN mkdir -p $VALHEIM_DIR
RUN steamcmd +login anonymous +force_install_dir $VALHEIM_DIR +app_update 896660 validate +quit

# Install Valheim Plus
RUN wget $VALHEIM_PLUS_URL -O /tmp/valheim_plus.tar.gz \
	&& tar -xzf /tmp/valheim_plus.tar.gz -C $VALHEIM_DIR \
	&& chmod +x /opt/valheim/start_server_bepinex.sh \
	&& ls -l /opt/valheim/start_server_bepinex.sh

# Ports required for Valheim
EXPOSE 2456-2458/udp

# Volume for persistence
VOLUME ${VALHEIM_SAVE}

# Command to run
CMD ["/bin/bash", "-c", "cd $VALHEIM_DIR && ./start_server_bepinex.sh"]