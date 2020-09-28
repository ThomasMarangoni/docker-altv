FROM debian:10
LABEL maintainer="DasChaos(Thomas Marangoni) <Twitter: @DasChaosAT>"

ARG BRANCH=release

ENV PORT 7788
ENV UID 0

RUN apt-get update && \
    apt-get install -y wget libc-bin libatomic1

RUN mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/resources-data && \
    mkdir -p /altv/modules/js-module && \
    # Download server
    wget -q --no-cache -O /altv/altv-server https://cdn.altv.mp/server/${BRANCH}/x64_linux/altv-server && \
    wget -q --no-cache -O /altv/data/vehmodels.bin https://cdn.altv.mp/server/${BRANCH}/x64_linux/data/vehmodels.bin && \
    wget -q --no-cache -O /altv/data/vehmods.bin https://cdn.altv.mp/server/${BRANCH}/x64_linux/data/vehmods.bin && \
    # Download js-module
    wget -q --no-cache -O /altv/modules/js-module/libjs-module.so https://cdn.altv.mp/js-module/${BRANCH}/x64_linux/modules/js-module/libjs-module.so && \
    wget -q --no-cache -O /altv/modules/js-module/libnode.so.72 https://cdn.altv.mp/js-module/${BRANCH}/x64_linux/modules/js-module/libnode.so.72

RUN apt-get purge -y wget && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/logs && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/resources && \
    mkdir /altv-persistend/node_modules && \
    mkdir /altv-persistend/resources-data && \
    ln -s /altv-persistend/logs /altv/logs && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/resources /altv/resources && \
    ln -s /altv-persistend/node_modules /altv/node_modules && \
    ln -s /altv-persistend/resources-data /altv/resources-data

EXPOSE ${PORT}/tcp
EXPOSE ${PORT}/udp

VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh
RUN chmod +x /altv/altv-server

USER ${UID}

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["bash"]
