FROM debian:stable
LABEL maintainer="DasChaos <Twitter: @DasChaosAT>"

RUN apt-get update && \
    apt-get install -y wget unzip

RUN wget --no-cache -O linux.zip https://alt-cdn.s3.nl-ams.scw.cloud/server-beta/linux.zip && \
    mkdir /altv && \
    unzip -d altv linux.zip && \
    rm linux.zip

RUN apt-get purge -y wget unzip && \
    apt-get clean

RUN mkdir /altv-persistend && \
    mkdir /altv-persistend/config && \
    mkdir /altv-persistend/resources && \
    mkdir /altv-persistend/logs && \
    rm -rf /altv/resources && \
    rm /altv/server.cfg && \
    rm /altv/start.sh && \
    ln -s /altv-persistend/config /altv/config && \
    ln -s /altv-persistend/resources /altv/resources && \
    ln -s /altv-persistend/logs /altv/logs

EXPOSE 7788
VOLUME /altv-persistend/

ADD start_server.sh /altv/start_server.sh
RUN chmod +x /altv/start_server.sh
RUN chmod +x /altv/altv-server

USER 0

ENTRYPOINT ["/altv/start_server.sh"]
CMD ["bash"]

