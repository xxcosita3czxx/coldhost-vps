#!/bin/bash
sleep 2
export HOME=/home/container
cd /home/container
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`
curl -Ls https://raw.githubusercontent.com/xxcosita3czxx/coldhost-vps/main/install.sh -o install.sh
chmod +x ./install.sh
sudo service cron start
# Run the VPS Installer
sh ./install.sh
