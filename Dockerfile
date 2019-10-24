FROM debian:10
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>, StiviK <info@stivik.de>"

# small fix for debian ci builds
ARG DEBIAN_FRONTEND=noninteractive

# Environment
ENV PORT 7788
ENV USER altv

# Install deps
RUN apt update && \
    apt install -y wget libc-bin

# Add altv user
RUN adduser --disabled-password --gecos "" ${USER} && \
    mkdir -p /home/${USER}/server
ENV HOME /home/${USER}/server
ENV ALTV_TMP /tmp/altvbin

# Download binaries
ARG BRANCH=stable
RUN mkdir -p ${ALTV_TMP}
RUN wget -q --no-cache -O ${ALTV_TMP}/altv-server https://cdn.altv.mp/server/${BRANCH}/x64_linux/altv-server && \
    wget -q --no-cache -O ${ALTV_TMP}/libnode-module.so https://cdn.altv.mp/node-module/${BRANCH}/x64_linux/modules/libnode-module.so && \
    wget -q --no-cache -O ${ALTV_TMP}/libnode.so.72 https://cdn.altv.mp/node-module/${BRANCH}/x64_linux/libnode.so.72 && \
    wget -q --no-cache -O ${ALTV_TMP}/vehmodels.bin https://cdn.altv.mp/server/${BRANCH}/x64_linux/data/vehmodels.bin && \
    wget -q --no-cache -O ${ALTV_TMP}/vehmods.bin https://cdn.altv.mp/server/${BRANCH}/x64_linux/data/vehmods.bin && \
    wget -q --no-cache -O ${ALTV_TMP}/server.cfg https://cdn.altv.mp/others/server.cfg && \
    mkdir -p ${HOME}/data && \
    mkdir -p ${HOME}/modules && \
    mkdir -p ${HOME}/resources-data && \
    mkdir -p ${HOME}/config && \
    mv ${ALTV_TMP}/altv-server ${HOME}/ && \
    mv ${ALTV_TMP}/libnode.so.72 ${HOME}/ && \
    mv ${ALTV_TMP}/vehmodels.bin ${HOME}/data && \
    mv ${ALTV_TMP}/vehmods.bin ${HOME}/data && \
    mv ${ALTV_TMP}/libnode-module.so ${HOME}/modules && \
    mv ${ALTV_TMP}/server.cfg ${HOME}/config && \
    rm -rf ${ALTV_TMP}/

RUN apt purge -y wget && \
    apt clean && \
    apt autoremove -y

RUN mkdir -p /var/volumes/altv && \
    mkdir /var/volumes/altv/config && \
    mkdir /var/volumes/altv/resources && \
    mkdir /var/volumes/altv/logs && \
    mkdir /var/volumes/altv/resources-data && \
    ln -s /var/volumes/altv/config ${HOME}/config && \
    ln -s /var/volumes/altv/resources ${HOME}/resources && \
    ln -s /var/volumes/altv/resources-data ${HOME}/resources-data && \
    ln -s /var/volumes/altv/logs ${HOME}/logs

# Expose persistend volume
RUN chown -R ${USER}:${USER} /var/volumes/altv
VOLUME /var/volumes/altv

# Expose ports and start the Server
WORKDIR /home/${USER}/server
ADD ./entrypoint.sh ./entrypoint.sh
EXPOSE ${PORT}/tcp
EXPOSE ${PORT}/udp

RUN chown -R ${USER}:${USER} .
RUN chmod +x altv-server
RUN chmod +x entrypoint.sh

USER ${USER}
ENTRYPOINT ["/bin/sh", "entrypoint.sh"]