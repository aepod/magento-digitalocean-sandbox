#!/bin/bash
echo "Starting scripts/puppet/initial_setup.sh"

if [[ ! -f ".vagrantlocks/hosts" ]]; then
	 sed -i 's/localhost/localhost puppet/g' /etc/hosts
    touch .vagrantlocks/hosts

fi

if [[ ! -f ".vagrantlocks/puppetserver" ]]; then
	echo "Doing some initial yum puppetserver install"
	  yum install -y puppet-server
	touch .vagrantlocks/puppetserver
fi

if [[ ! -f ".vagrantlocks/puppetconfig" ]]; then
	echo "Configuring puppetmaster"
	rm -rf /etc/puppet
	cp -R /vagrant/puppet/ /etc/puppet
	puppet master
	puppet agent -t
    touch .vagrantlocks/puppetconfig
    echo 'Started puppetmaster'
fi

if [[ ! -f ".vagrantlocks/puppetdb" ]]; then
	echo "Configuring puppetdb"
	
	puppet resource package puppetdb ensure=latest
    puppet resource package puppetdb-terminus ensure=latest
	puppet resource service puppetdb ensure=running enable=true
	puppet resource service puppetmaster ensure=running enable=true

	cp /etc/puppet/puppetdb-jetty.ini /etc/puppetdb/conf.d/jetty.ini
	puppetdb ssl-setup
	
	cp /etc/puppet/puppet.conf-withdb /etc/puppet/puppet.conf
	for i in puppetdb puppetmaster ; do sudo service $i restart ; done
	
    echo 'Puppetdb Bootstrap complete'
	touch .vagrantlocks/puppetdb
fi


echo "You will need to add the internal network IP to the Vagrantfile"
echo "See line 5 in the projects Vagrantfile - This is required for all other boxes to work"
echo "Puppet IP: "
facter ipaddress_eth1
echo "------------------------"
echo "To connect to the puppet box use the external ip:"
echo "Puppet IP: "
facter ipaddress_eth0

echo "Finished scripts/puppet/initial_setup.sh"