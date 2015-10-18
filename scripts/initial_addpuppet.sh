#!/bin/bash
echo "Starting scripts/initial_addpuppet.sh"

puppethost=$1
fqdn=$(facter fqdn)

if [[ ! -f ".vagrantlocks/puppethostadd" ]]; then
	echo "$puppethost	puppet" >> /etc/hosts
    touch .vagrantlocks/puppethostadd
else
	echo "Puppetmaster host already added. --skipping"
fi


if [[ ! -f ".vagrantlocks/puppetagent" ]]; then
	echo "Installing Puppet using yum"
	yum install -y puppet

	echo "Configuring puppet agent and self signing with puppetmaster"	
	puppet agent -t
	sleep 5
	ssh -oStrictHostKeyChecking=no root@puppet puppet cert sign --all

    echo 'Puppet Agent should be signed and ready to go'
	puppet agent -t
	
	
    touch .vagrantlocks/puppetagent

else
	echo "Puppet Agent already configured. --skipping"	
fi

echo "Finished scripts/initial_addpuppet.sh"