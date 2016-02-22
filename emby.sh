#!/bin/bash

# Fix the timezone
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

# Adjust UID and GID of nobody with environmet variables
USER_ID=${EMBY_USERID:-99}
GROUP_ID=${EMBY_GROUPID:-100}
groupmod -g $GROUP_ID users
usermod -u $USER_ID nobody
usermod -g $GROUP_ID nobody
usermod -d /home nobody

# Set right permission for directories
USER="nobody"
HOME_PATH=/usr/lib/emby-server
PROGRAMDATA=/config
HOME_CURRENT_USER=`ls -lad $HOME_PATH | awk '{print $3}'`
DATA_CURRENT_USER=`ls -lad $PROGRAMDATA | awk '{print $3}'`
if [ "$HOME_CURRENT_USER" != "$USER" ]; then
    chown -R "${USER}:users $DAEMON_PATH"
fi
if [ "$DATA_CURRENT_USER" != "$USER" ]; then
    chown -R "$USER":users "$PROGRAMDATA"
fi

# Run emby server
cd $HOME_PATH/bin/
exec env MONO_THREADS_PER_CPU=100 MONO_GC_PARAMS=nursery-size=64m /sbin/setuser nobody mono-sgen $HOME_PATH/bin/MediaBrowser.Server.Mono.exe \
  -programdata /config \
  -ffmpeg $(which ffmpeg) \
  -ffprobe $(which ffprobe) \
  -restartpath "/Restart.sh" \
	-restartargs ""
