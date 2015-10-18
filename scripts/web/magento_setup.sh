#!/bin/bash
echo "Starting scripts/web/magento_setup.sh"

if [[ ! -f "/usr/local/bin/n98-magerun.phar" ]]; then
	echo "Adding n98-magerun"
	wget https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar -O /usr/local/bin/n98-magerun.phar &> /dev/null
	chmod +x /usr/local/bin/n98-magerun.phar
fi

if [[ ! -f "/root/.n98-magerun.yaml" ]]; then
	echo "Adding n98-magerun configuration file at /root/.n98-magerun.yaml"
	cp /vagrant/scripts/web/n98-config.yaml /root/.n98-magerun.yaml
fi

# 
# Delete /root/.vagrantlocks/magentoinstall to reprovision
if [ ! -f ".vagrantlocks/magentoinstall" ] && [ -f "/usr/local/bin/n98-magerun.phar" ] && [ -f "/root/.n98-magerun.yaml" ]; then
	echo "Installing Magento"
	mkdir -p /var/www/html/

	/usr/local/bin/n98-magerun.phar install -n --dbHost="db" --dbUser="magento" --dbPass="5678password" --dbName="magento" --installSampleData=no --useDefaultConfigParams=yes --magentoVersionByName="magento1910" --installationFolder="/var/www/html/" --baseUrl="http://www.idealphp.com/"
	chown -R wwwusr:wwwusr /var/www/html/

	# Modify app/etc/local to use redis
	cp /vagrant/scripts/web/local.xml /var/www/html/app/etc/
	
	# Add symlinks for media/
	echo "Creating symbolic links for shared media"
	mv /var/www/html/media /shared/website/
	chown -R wwwusr:wwwusr /shared/website/media/
	chmod -R 777 /shared/website/media/
	ln -s /shared/website/media /var/www/html/media

	echo "Adding the Magento Performance Toolkit from https://github.com/aepod/magento-performance-toolkit "
	cd /root/
	wget https://github.com/aepod/magento-performance-toolkit/archive/master.zip -O /root/mpt.zip &> /dev/null
	unzip mpt.zip &> /dev/null
	mkdir -p /var/www/html/dev/tools/performance_toolkit/
	cp -R /root/magento-performance-toolkit-master/1.9ce/* /var/www/html/dev/tools/performance_toolkit/
	cd /var/www/html/dev/tools/performance_toolkit/
	rm -rf ./tmp/
	php -f ./generate.php -- --profile=profiles/scaling_tutorial.xml
	cd /root/
    touch .vagrantlocks/magentoinstall	
else
	echo "Cannot install Magento, if you intended to install it please delete /root/.vagrantlocks/magentoinstall and reprovision"
fi

echo "Finished scripts/web/magento_setup.sh"