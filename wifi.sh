#!/bin/sh
# /etc/rc.d/wifi : start/stop wifi connection

INTERFACE="wlp3s0"
WPA_CONF="/etc/wpa_supplicant/wpa_supplicant.conf"

case "$1" in
  start)
    echo "Starting WiFi..."
    /usr/sbin/wpa_supplicant -B -i $INTERFACE -c $WPA_CONF
    /usr/bin/dhcpcd $INTERFACE
    ;;
  stop)
    echo "Stopping WiFi..."
    killall wpa_supplicant
    killall dhcpcd
    ;;
  restart)
    $0 stop
    sleep 2
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
