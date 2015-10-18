#!/bin/bash

echo "Starting scripts/web/initial_setup.sh"

if [[ ! -f "/root/deploy_application.sh" ]]; then
	cp /vagrant/scripts/web/deploy_application.sh /root/
	chmod u+x /root/deploy_application.sh
fi

if [[ ! -f ".vagrantlocks/puppetcron" ]]; then
	puppet config set runinterval 90
	service puppet start
    touch .vagrantlocks/puppetcron	
else
	echo "Puppet agent already configured."
fi

echo "Finished scripts/web/initial_setup.sh"
