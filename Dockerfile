FROM babim/debianbase

# Configure user nobody to match unRAID's settings
RUN export DEBIAN_FRONTEND='noninteractive' && \
    groupmod -g 100 users && \
    usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /home nobody && \
    chown -R nobody:users /home

# add source repo
RUN wget http://download.opensuse.org/repositories/home:emby/Debian_8.0/Release.key && \
    apt-key add - < Release.key && rm -f Release.key && \
    echo 'deb http://download.opensuse.org/repositories/home:/emby/Debian_8.0/ /' > /etc/apt/sources.list.d/emby-server.list && \
    echo 'deb http://www.deb-multimedia.org jessie main non-free' > /etc/apt/sources.list.d/deb-multimedia.list && \
    apt-get update && apt-get install -y --force-yes deb-multimedia-keyring

# Install Dependencies
RUN apt-get update -qq && \
    apt-get install -qy --force-yes mono-runtime \
    mediainfo wget libsqlite3-dev libc6-dev ffmpeg libembymagickwand-6.q8-2 libembymagickcore-6.q8-2 \
    sudo imagemagick emby-server

#########################################
##                 CLEANUP             ##
#########################################
# Clean APT install files
RUN apt-get clean -y && apt-get autoremove -y && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/*

COPY emby.sh /usr/bin/
RUN chmod +x /usr/bin/emby.sh
ENTRYPOINT ["emby.sh"]

VOLUME ["/config", "/media"]
EXPOSE 8096 8920 7359/udp 1900/udp
