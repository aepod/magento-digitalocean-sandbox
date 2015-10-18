#!/bin/bash
echo "Starting scripts/output_status.sh"
currentHost=$1

echo "Setup complete on $currentHost"
echo "To connect to the $currentHost box use the external ip:"
echo "$currentHost External IP: "
facter ipaddress_eth0
echo "------------------------"
echo "$currentHost Internal IP: "
facter ipaddress_eth1

