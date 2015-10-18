#!/bin/bash

# Deploy application is used to push /var/www/html/ to all render servers
# This get placed in the /root/ directory on the web node.
# Checks via ping to see if the host is up,
#  if its up, it rsyncs everything over.
# - Quick and dirty deploy

if ping -c 1 render1 &> /dev/null
then
  echo "Rsync /var/www/html/ to render1"
	# Skip the nonesense, we are in a sandbox
	# who needs a ssh-keyscan ?
	ssh -oStrictHostKeyChecking=no root@render1 echo "hi" &> /dev/null  
	ssh -oStrictHostKeyChecking=no root@render1 puppet agent -t
	rsync -a /var/www/html/ root@render1:/var/www/html/
fi

if ping -c 1 render2 &> /dev/null
then
  echo "Rsync /var/www/html/ to render2"
	# Skip the nonesense, we are in a sandbox
	# who needs a ssh-keyscan ?
	ssh -oStrictHostKeyChecking=no root@render2 echo "hi" &> /dev/null  
	ssh -oStrictHostKeyChecking=no root@render2 puppet agent -t
	rsync -a /var/www/html/ root@render2:/var/www/html/
fi

if ping -c 1 render3 &> /dev/null
then
  echo "Rsync /var/www/html/ to render3"
	# Skip the nonesense, we are in a sandbox
	# who needs a ssh-keyscan ?
	ssh -oStrictHostKeyChecking=no root@render3 echo "hi" &> /dev/null  
	ssh -oStrictHostKeyChecking=no root@render3 puppet agent -t
	rsync -a /var/www/html/ root@render3:/var/www/html/
fi

if ping -c 1 render4 &> /dev/null
then
  echo "Rsync /var/www/html/ to render4"
  	# Skip the nonesense, we are in a sandbox
	# who needs a ssh-keyscan ?
	ssh -oStrictHostKeyChecking=no root@render4 echo "hi" &> /dev/null
	ssh -oStrictHostKeyChecking=no root@render4 puppet agent -t
	rsync -a /var/www/html/ root@render4:/var/www/html/
fi
