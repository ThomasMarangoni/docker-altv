FROM debian:10
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

RUN apt-get update && \
    apt-get install -y wget libc-bin

RUN wget --no-cache -O altv-server https://cdn.altv.mp/server/stable/x64_linux/altv-server && \
    wget --no-cache -O libnode.so.64  https://cdn.altv.mp/alt-node/libnode.so.64 && \
    wget --no-cache -O vehmodels.bin https://cdn.altv.mp/server/stable/x64_linux/data/vehmodels.bin&& \
    wget --no-cache -O vehmods.bin https://cdn.altv.mp/server/stable/x64_linux/data/vehmods.bin && \
    wget --no-cache -O libnode-module.so https://alt-cdn.s3.nl-ams.scw.cloud/node-module/stable/x64_linux/libnode-module.so && \
    mkdir /altv && \
    mkdir /altv/data && \
    mkdir /altv/modules && \
    mkdir /altv/resources-data && \
    mv altv-server /altv/ && \
    mv libnode.so.64 /altv/ && \
    mv vehmodels.bin /altv/data && \
    mv vehmods.bin /altv/data && \
    mv libnode-module.so /altv/modules

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

EXPOSE 7788/tcp
EXPOSE 7788/udp

VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh
RUN chmod +x /altv/altv-server

USER 0

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["bash"]

