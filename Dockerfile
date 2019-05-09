FROM debian:9
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

RUN apt-get update && \
    apt-get install -y wget unzip


RUN wget --no-cache https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_linux/server.zip && \
    mkdir /altv && \
    unzip -d altv server.zip && \
    rm server.zip && \
    chmod +x /altv/altv-server

RUN apt-get purge -y wget unzip && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/ressources && \
    mkdir /altv-persistend/logs && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/ressources /altv/ressources && \
    ln -s /altv-persistend/logs /altv/logs

EXPOSE 7788
VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh

USER 0

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["sh"]

