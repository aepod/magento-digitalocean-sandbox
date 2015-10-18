# Version of MySQL you want. At the time of this writing (2014-09-09) it can be 5.5 or 5.6.
$mysqlversion = "5.6"

# Root password of all of the MySQL/MariaDB servers...
$mysqlrootpw = 'du9bnd7und30988'

# Mysql Override options - https://forge.puppetlabs.com/puppetlabs/mysql
$override_options = { }

# Name of the Base URL for sites in this instance...
$baseurl = "www.idealphp.com"

# UID of the webserver, the account name is "wwwusr"
$wwwuid = "800"

$sharedstoragetarget = "/shared"

$clusterroothash = '$6$LsvR5F9v$OXBf1I5eDSF4hJRU49NzBjT4NTZdgG9.w9HafK9nH15t0HL4wIDrCRwRBEv3/bHj6wQYTFkK1Jmrk.wmdlgN81'

$newrelicLicenseKey = ''



# Name of the management server in this instance...
#	I could have made this exported, but then you'd need
#	a database to bootstrap puppet, that's not fun.
$mgmtserver = "puppet.idealphp.com"

########################################################################
#               You needn't go below here much, ideally                #
#  Node definitions can also be done with an ENC like LDAP or Foreman  #
########################################################################

import "functions.pp"
include utilities::nscd
include utilities::useful
include utilities::rootpw
  
if $newrelicLicenseKey == '' {
  notice( 'Set a Newrelic License key on puppet server to use Newrelic.' )
}
else  {
	 class {'newrelic::server::linux':
	   newrelic_license_key => $newrelicLicenseKey,
	 }
}

node 'puppet' {

}

node 'jmeter' {

}

node 'db' {

	$override_options = {
	  'mysqld' => {
	    'bind-address' => $ipaddress_eth1,
	  }
	}
	class { '::mysql::server':
	  root_password           => $mysqlrootpw,
	  remove_default_accounts => true,
	  override_options        => $override_options
	}
	mysql::db { 'magento':
	  user     => 'magento',
	  password => '5678password',
	  host     => '%',
	  grant    => ['ALL'],
	}
	
	class { 'redis':
	}
	redis::instance { 'redis-6380':
	  redis_port         => '6380',
	  redis_max_memory   => '1gb',
	}
	redis::instance { 'redis-6381':
	  redis_port         => '6381',
	  redis_max_memory   => '1gb',
	}
	include daemons::nginx::usergroup
	include nfs::server
	
}

  
node 'monolith' {
	$override_options = {
	  'mysqld' => {
	    'bind-address' => $ipaddress_eth1,
	  }
	}
	class { '::mysql::server':
	  root_password           => $mysqlrootpw,
	  remove_default_accounts => true,
	  override_options        => $override_options
	}
	mysql::db { 'magento':
	  user     => 'magento',
	  password => '5678password',
	  host     => '%',
	  grant    => ['ALL'],
	}
	
	class { 'redis':
	}
	redis::instance { 'redis-6380':
	  redis_port         => '6380',
	  redis_max_memory   => '1gb',
	}
	redis::instance { 'redis-6381':
	  redis_port         => '6381',
	  redis_max_memory   => '1gb',
	}
	include daemons::nginx::usergroup
	include nfs::server
	include daemons::nginx::server
	include daemons::nginx::php
	
	if $newrelicLicenseKey == '' {
	  notice( 'Set a Newrelic License key on puppet server to use Newrelic.' )
	}
	else  {
		$newrelicAppname = 'Magento Monolith'
		 class {'newrelic::agent::php':
		   newrelic_license_key  => $newrelicLicenseKey,
		   newrelic_ini_appname  => $newrelicAppname,
		 }	
	}


	
}

node /render\d+.*/ {
	include daemons::nginx::usergroup
	include daemons::nginx::server
	include daemons::nginx::php
	include nfs::client
  @@haproxy::balancermember { "${hostname}":
    listening_service => 'web',
    server_names      => $::hostname,
    ipaddresses       => $ipaddress_eth0,
    ports             => '80',
  	options           => 'check',  
  }
	if $newrelicLicenseKey == '' {
	  notice( 'Set a Newrelic License key on puppet server to use Newrelic.' )
	}
	else  {
		$newrelicAppname = 'Magento Cluster'
		 class {'newrelic::agent::php':
		   newrelic_license_key  => $newrelicLicenseKey,
		   newrelic_ini_appname  => $newrelicAppname,
		 }	
	}
	
}

node 'www' {
class { 'haproxy':
  global_options   => {
    'maxconn' => '8000'
  },
  defaults_options => {
    'log'     => 'global',
    'stats'   => 'enable',
    'option'  => 'redispatch',
    'retries' => '3',
    'timeout' => [
      'http-request 10s',
      'queue 1m',
      'connect 10s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => '8000',
  },
}  
  haproxy::listen { 'web':
    collect_exported => true,
    ipaddress        => $ipaddress_eth0,
    ports            => '80',
    mode			 => 'http',
	  options   => {
	    'option'  => [
	      'httpchk GET /',
	    ],
	    'balance' => 'leastconn',
	  },    
  }
  Haproxy::Balancermember <<| listening_service == 'web' |>>
  


  include daemons::nginx::usergroup
  include daemons::nginx::php
  include nfs::client
  
	if $newrelicLicenseKey == '' {
	  notice( 'Set a Newrelic License key on puppet server to use Newrelic.' )
	}
	else  {
		$newrelicAppname = 'Magento Cluster'
		 class {'newrelic::agent::php':
		   newrelic_license_key  => $newrelicLicenseKey,
		   newrelic_ini_appname  => $newrelicAppname,
		 }	
	}
  
  
}