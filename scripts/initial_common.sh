#!/bin/bash
echo "Starting scripts/initial_common.sh"


if [[ ! -d ".vagrantlocks" ]]; then
    mkdir .vagrantlocks
    echo 'Created vagrant lock directory in ~/.vagrantlocks'
fi

if [[ ! -f ".vagrantlocks/iptables" ]]; then
	echo "Disable IP Tables for the demo"
	service iptables stop
	chkconfig iptables off
    touch .vagrantlocks/iptables
else
	echo "IP Tables already disabled. --skipping"
fi


if [[ ! -f ".vagrantlocks/baseyum" ]]; then
	echo "Doing some initial yum installing"
	# yum update -y
	rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/epel-release-6-5.noarch.rpm  &> /dev/null
    rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-13.ius.centos6.noarch.rpm  &> /dev/null
	yum -y install pv nano telnet man vim bash-completion &> /dev/null
    touch .vagrantlocks/baseyum
else
	echo "Pre-puppet yum install already done. --skipping"
fi

if [[ ! -f ".vagrantlocks/puppetrepo" ]]; then
	echo "Adding Puppet Repo"
	rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
	touch .vagrantlocks/puppetrepo
else
	echo "Puppet repository was already added. --skipping"	
fi

if [[ ! -f ".vagrantlocks/rootsshkey" ]]; then
	# copy id_rsa from vagrant to /root
	cp /vagrant/ssh/id_rsa* /root/.ssh/
	
	# change permissions on id_rsa files
	chmod 600 /root/.ssh/id_rsa*
	
	# add id_rsa.pub to authorized_keys
	cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
else
	echo "Shared Keys already shared. Damage is done... don't do this at home --skipping"	
fi

echo "Finished scripts/initial_common.sh"
