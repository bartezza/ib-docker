#!/bin/bash

Xvfb :1 -screen 0 1024x768x24 2>&1 >/dev/null &
export DISPLAY=:1

sleep 2

x11vnc -passwd $VNC_PASSWORD -N -forever -rfbport 5900 &
# -display :1

#xvfb-run -a /opt/IBController/Scripts/DisplayBannerAndLaunch.sh &
#xvfb-run -a /opt/IBC/scripts/displaybannerandlaunch.sh &

/opt/IBC/scripts/displaybannerandlaunch.sh &

# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) # &

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
#sleep 20
#echo "Forking :::4001/4002 onto 0.0.0.0:4003/4004\n"
#socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001
#socat TCP-LISTEN:4004,fork TCP:127.0.0.1:4002

echo "Just waiting..."
wait
