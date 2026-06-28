#!/bin/bash

set -e

# Default password if none is provided
RDP_PASSWORD="${RDP_PASSWORD:-password}"

echo "======================================"
echo " Starting XRDP Container"
echo "======================================"

# Create user if it doesn't exist
if ! id -u user >/dev/null 2>&1; then
    useradd -m -s /bin/bash user
fi

# Set password
echo "user:${RDP_PASSWORD}" | chpasswd

# Add user to sudo group
usermod -aG sudo user

# Configure XFCE session
echo "startxfce4" > /home/user/.xsession
chown user:user /home/user/.xsession

# Create runtime directory
mkdir -p /run/dbus

# Start D-Bus
dbus-daemon --system

# Start PulseAudio for the user
su - user -c "pulseaudio --start || true"

# Ensure XRDP runtime directory exists
mkdir -p /var/run/xrdp
chown xrdp:xrdp /var/run/xrdp

echo "Starting XRDP services..."

# Start sesman
/usr/sbin/xrdp-sesman

# Start XRDP in foreground
exec /usr/sbin/xrdp --nodaemon
