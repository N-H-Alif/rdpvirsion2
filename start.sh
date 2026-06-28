#!/bin/bash
set -e
mkdir -p /var/run/dbus /tmp/.X11-unix
dbus-daemon --system --fork || true
pulseaudio --start || true
service xrdp start
service xrdp-sesman start
trap "service xrdp stop; service xrdp-sesman stop" EXIT
tail -F /var/log/xrdp.log /var/log/xrdp-sesman.log
