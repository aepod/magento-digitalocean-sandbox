# magento-digitalocean-sandbox

A vagrant puppet cluster for demonstrating how to use haproxy to load balance web nodes and single database. 

This utilizes Digital Ocean and requires a Digital Ocean account with a valid token. 

You will also need the vagrant digital ocean provider:
https://github.com/smdahlen/vagrant-digitalocean

---
There are a few things that are not production ready:

1. Root password is: `puppet`. You can login as root on SSH.
2. Root has a shared key between boxes, this is for self-signing on puppet
3. Pupppet master is gimped overall, its not controlled via puppet and its not running passenger, or postgres for puppetdb.
4. It uses www.idealphp.com as its domain and sets a network of secondary IP's to make it easier to demonstrate:

---
To use this:

1. Install vagrant
2. Checkout from github
3. CMD Prompt in the directory you checked out
4. `vagrant up puppet` 
5. Grab the internal IP and set it on line 6 in the Vagrantfile.  * DO NOT MISS THIS STEP *
6. To stand up the cluster `vagrant up db web render1 jquery`
7. Note the external IP of the Web node, set this ip to www.idealphp.com in in your local hosts file.
8. Point your web browser or test scripts there

---
Monolith: 
A single box, with web, db, redis. Still requires the puppetmaster to be up. 
To use:
1. Ensure puppet is up `vagrant up puppet`
2. Bring up monolith `vagrant up monolith`
3. Note the external IP of the Monolith node, set this ip to www.idealphp.com in your local hosts file.
4. Point your web browser or test scripts there

---
haproxy stats available once web is up at: 
http://www.idealphp.com/haproxy?stats

---
Puppet Modules:

- MySQL: https://forge.puppetlabs.com/puppetlabs/mysql
- Redis: https://forge.puppetlabs.com/thomasvandoren/redis
- HAProxy: https://forge.puppetlabs.com/puppetlabs/haproxy
- New Relic: https://forge.puppetlabs.com/fsalum/newrelic

---
Magento Performance Toolkit:

For some background see: http://aepod.com/using-the-magento-performance-toolkit/

This gets installed and run with the standup on the web servers. You do not need to import the profiles etc, if you ran the magento setup scripts with the stand up, everything should be automated.

You will need to standup the jmeter server to use the built in jmeter tests.  Look in /usr/local/apache-jmeter/ you will find the Java and jmeter already installed, and the tests will be in the tests/ directory. You may need to edit the host file if you are testing against monolith.


To Use: TBD

---
TODO:

1. Improve puppetmaster standup (still need to set ip in vagrantfile etc)
2. Improve deployments
3. Add ELK Stack to Cluster
4. Clean up Root password crap
5. Zend Server Monolith?


---
The MIT License (MIT)

Copyright (c) 2015 Mathew Beane
See LICENSE.txt for full license
