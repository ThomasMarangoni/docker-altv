FROM debian:10
LABEL maintainer="DasChaos(Thomas Marangoni) <Twitter: @DasChaosAT>"

ARG branch=stable

ENV PORT 7788
ENV UID 0

RUN apt-get update && \
    apt-get install -y wget libc-bin jq

RUN mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/modules && \
    mkdir /altv/resources-data && \
    buildNumber=$(wget --no-cache -qO- https://cdn.altv.mp/server/${branch}/x64_linux/update.json | jq '.latestBuildNumber') && \
    wget --no-cache -O /altv/altv-server https://cdn.altv.mp/server/${branch}/x64_linux/altv-server?salt=$buildNumber && \
    wget --no-cache -O /altv/modules/libnode-module.so https://cdn.altv.mp/node-module/${branch}/x64_linux/modules/libnode-module.so?salt=$buildNumber && \
    wget --no-cache -O /altv/libnode.so.72 https://cdn.altv.mp/node-module/${branch}/x64_linux/libnode.so.72?salt=$buildNumber && \
    wget --no-cache -O /altv/data/vehmodels.bin https://cdn.altv.mp/server/${branch}/x64_linux/data/vehmodels.bin?salt=$buildNumber && \
    wget --no-cache -O /altv/data/vehmods.bin https://cdn.altv.mp/server/${branch}/x64_linux/data/vehmods.bin?salt=$buildNumber

RUN apt-get purge -y wget jq && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/resources && \
    mkdir /altv-persistend/logs && \
    mkdir /altv-persistend/resources-data && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/resources /altv/resources && \
    ln -s /altv-persistend/resources-data /altv/resources-data && \
    ln -s /altv-persistend/logs /altv/logs

EXPOSE ${PORT}/tcp
EXPOSE ${PORT}/udp

VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh
RUN chmod +x /altv/altv-server

USER ${UID}

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["bash"]

