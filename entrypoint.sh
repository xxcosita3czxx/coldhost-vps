#!/bin/bash
sleep 2
export HOME=/home/container
cd /home/container
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`
curl -Ls https://raw.githubusercontent.com/xxcosita3czxx/coldhost-vps/main/install.sh -o install.sh
chmod +x ./install.sh
chmod +x /usr/local/bin/traffic_monitor.sh
# Set up the cron job
(crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/traffic_monitor.sh") | crontab -

# Ensure cron is started
service cron start
# Run the VPS Installer
sh ./install.sh
