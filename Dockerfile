###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd:root

ENV STEAMAPPID 629800
ENV STEAMAPPDIR /home/steam/mordhau-dedicated

RUN set -x \
# Install Mordhau server dependencies and clean up
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1=2.11.0-6.7+b1 \
		libpangocairo-1.0-0=1.40.5-1 \
		libnss3=2:3.26.2-1.1+deb9u1 \
		libgconf2-4=3.2.6-4+b1 \
		libxi6=2:1.7.9-1 \
		libxcursor1=1:1.1.14-1+deb9u2 \
		libxss1=1:1.2.2-1 \
		libxcomposite1=1:0.4.4-2 \
		libasound2=1.1.3-5 \
		libxdamage1=1:1.1.4-2+b3 \
		libxtst6=2:1.2.3-1 \
		libatk1.0-0=2.22.0-1 \
		libxrandr2=2:1.5.1-1 \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
# Run Steamcmd and install Mordhau
	&& su steam -c \
	    "mkdir -p ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/ \
	    mkdir -p ${STEAMAPPDIR}/Mordhau/Content/Mordhau/Maps \
		&& ${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} validate \
		+quit"

ENV SERVER_PORT=7777 \
	SERVER_QUERYPORT=27015 \
	SERVER_BEACONPORT=15000

# Switch to user steam
USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

# Set Entrypoint
# 1. Update server
# 2. Copy config and map files
# 3. Start the server
ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
			+login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit \
		# copy files from /tmp
		&& cp -vr /tmp/mordhau/config/* ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/ \
		&& cp -vr /tmp/mordhau/maps/* ${STEAMAPPDIR}/Mordhau/Content/Mordhau/Maps/ \
		&& ${STEAMAPPDIR}/MordhauServer.sh -log \
			-Port=$SERVER_PORT -QueryPort=$SERVER_QUERYPORT -BeaconPort=$SERVER_BEACONPORT \
			-GAMEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
			-ENGINEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini

# Expose ports
EXPOSE 27015 15000 7777
