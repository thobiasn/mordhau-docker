###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM debian:latest

# installation vars
ENV STEAMAPPID 629800
ENV STEAMCMDDIR "/home/steam"
ENV STEAMAPPDIR "/home/steam/mordhau-dedicated"

# configurable vars
ENV SERVER_PORT=7777
ENV SERVER_QUERYPORT=27015 
ENV SERVER_BEACONPORT=15000
ENV SERVER_RCONPORT=0

# install dependencies
RUN apt-get update \
	&& apt-get install lib32gcc1 curl -y \
	&& useradd -ms /bin/bash steam

# install steamcmd and mordhau
USER steam
WORKDIR ${STEAMCMDDIR}
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - \
	&& mkdir -p ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/ \ 
	&& ${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} validate \
		+quit

# set entry point - move configs and mods
WORKDIR $STEAMAPPDIR
VOLUME $STEAMAPPDIR

ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} validate \
		+quit \
	&& cp -vr /tmp/mordhau/config/* ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/ \
	&& cp -vr /tmp/mordhau/paks/* ${STEAMAPPDIR}/Mordhau/Content/Paks/ \
	&& ${STEAMAPPDIR}/MordhauServer.sh -log \
			-Port=$SERVER_PORT -RconPort=$SERVER_RCONPORT -QueryPort=$SERVER_QUERYPORT -BeaconPort=$SERVER_BEACONPORT \
			-GAMEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
			-ENGINEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini

# Expose ports
EXPOSE ${SERVER_PORT}
EXPOSE ${SERVER_QUERYPORT}
EXPOSE ${SERVER_BEACONPORT}
EXPOSE ${SERVER_RCONPORT}
