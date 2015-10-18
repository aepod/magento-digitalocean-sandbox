#!/bin/bash
echo "Starting scripts/render/initial_setup.sh"

# Running puppet here, because it fails as an provider in vagrant
puppet agent -t
puppet agent -t
# Twice, if only I could get the order right.

if [[ ! -f ".vagrantlocks/magento" ]]; then
	# who needs a ssh-keyscan ?
	ssh -oStrictHostKeyChecking=no root@www echo "hi" &> /dev/null
	
	# copy files from web
	mkdir -p /var/www/html
	rsync -a root@www:/var/www/html/ /var/www/html/
	
	
	# Give the server a kick
	service nginx restart
	service php-fpm restart
	touch .vagrantlocks/magento
fi

echo "Finished scripts/render/initial_setup.sh"