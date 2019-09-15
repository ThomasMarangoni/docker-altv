FROM debian:10
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

ENV PORT 7788
ENV UID 0

RUN apt-get update && \
    apt-get install -y wget libc-bin

RUN mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/modules && \
    mkdir /altv/resources-data && \
    wget --no-cache -O /altv/altv-server https://cdn.altv.mp/server/stable/x64_linux/altv-server && \
    wget --no-cache -O /altv/modules/libnode-module.so https://cdn.altv.mp/node-module/stable/x64_linux/modules/libnode-module.so && \
    wget --no-cache -O /altv/libnode.so.72 https://cdn.altv.mp/node-module/stable/x64_linux/libnode.so.72 && \
    wget --no-cache -O /altv/data/vehmodels.bin https://cdn.altv.mp/server/stable/x64_linux/data/vehmodels.bin&& \
    wget --no-cache -O /altv/data/vehmods.bin https://cdn.altv.mp/server/stable/x64_linux/data/vehmods.bin

RUN apt-get purge -y wget && \
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

