FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y     xrdp xfce4 xfce4-goodies xorg dbus-x11 sudo curl wget nano net-tools     policykit-1 pulseaudio pulseaudio-utils wine wine32 firefox-esr tini     && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "root:root" | chpasswd
RUN echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config || true
RUN echo "startxfce4" > /root/.xsession && chmod 700 /root/.xsession
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini || true
RUN sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini || true
RUN printf '#!/bin/sh
exec startxfce4
' > /etc/xrdp/startwm.sh && chmod +x /etc/xrdp/startwm.sh
RUN adduser xrdp ssl-cert || true
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 3389
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["/start.sh"]
