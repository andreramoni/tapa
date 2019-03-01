#!/bin/bash
##############################
# This script is called by packer and
# already run with sudo.

echo
echo "-------------------------------------------"
echo "    Provisioning script."
echo "    Installing NGInx... "
echo "-------------------------------------------"

yum install -y epel-release
yum install -y nginx
systemctl enable nginx


