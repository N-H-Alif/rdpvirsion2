FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    dbus-x11 \
    sudo \
    wget \
    curl \
    nano \
    supervisor \
    pulseaudio \
    pulseaudio-utils \
    wine \
    tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash user

RUN echo "user:${RDP_PASSWORD:-password}" | chpasswd

COPY start.sh /start.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY pulse-client.conf /etc/pulse/client.conf

RUN chmod +x /start.sh

EXPOSE 3389

ENTRYPOINT ["/usr/bin/tini","--"]

CMD ["/start.sh"]
