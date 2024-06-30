FROM ubuntu:latest

# Set noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        curl \
        ca-certificates \
        iproute2 \
        xz-utils \
        bzip2 \
        sudo \
        adduser \
        ifstat \
        iptables \
        cron \
        bc \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --home /container container

USER container
ENV USER container
ENV HOME /
WORKDIR /

# Copy the traffic monitoring script
COPY ./traffic_monitor.sh /usr/local/bin/traffic_monitor.sh
RUN chmod +x /usr/local/bin/traffic_monitor.sh

# Create the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set up the cron job
RUN echo "* * * * * /usr/local/bin/traffic_monitor.sh" | sudo crontab -u container -

# Start cron and the entrypoint script
CMD ["sudo", "cron", "-f", "&&", "/bin/bash", "/entrypoint.sh"]
