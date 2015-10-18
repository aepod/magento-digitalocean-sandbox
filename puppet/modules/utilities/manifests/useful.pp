class utilities::useful {

	package {
		"htop":
			ensure => present;
		"iftop":
			ensure => present;
		"psmisc":
			ensure => present;
        "git":
            ensure => present;
        "wget":
            ensure => present;
        "zip":
            ensure => present;
        "unzip":
            ensure => present;
	}

	@@host {
		"$::fqdn":
			host_aliases => "$::hostname",
			ip => "$::ipaddress_eth1",
			tag => "announce";
	}

	Host <<| tag == "announce" |>>

}
