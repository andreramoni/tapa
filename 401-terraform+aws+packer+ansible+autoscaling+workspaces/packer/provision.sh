#!/bin/bash
##############################
# This script is called by packer and
# already run with sudo.

echo
echo "-------------------------------------------"
echo "    Provisioning script."
echo "    Doing nothing. Will do with ansible."
echo "-------------------------------------------"

echo "ip addr sh dev eth0 | grep 'inet ' | awk '{ print \$2 \"version 1\" }' > /usr/share/nginx/html/index.html" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local


