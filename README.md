[![](https://images.microbadger.com/badges/image/babim/emby.svg)](https://microbadger.com/images/babim/emby "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/emby.svg)](https://microbadger.com/images/babim/emby "Get your own version badge on microbadger.com")

## Description:

This is a Dockerfile for "Emby Server" - (http://emby.media/)

## How to use:

```
docker run -d --net=host -v /*your_config_location*:/config -v /*your_media_location*:/media -e TZ=<TIMEZONE> --name=EmbyServer babim/emby
```

## Volumes:

#### `/config`

Configuration files and state of MediaBrowser Server folder. (i.e. /opt/appdata/emby or /mnt/cache/.appdata/emby)

## Environment Variables:

### `TZ`

TimeZone. (i.e America/Edmonton)

### `EMBY_USERID`

User ID emby should run under, default is 99 for unRAID compatiability.

### `EMBY_GROUPID`

Group ID emby should run under, default is 100 for unRAID compatiability.
