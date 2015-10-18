class utilities::rootpw ( ) {

	user {
		"root":
			uid => 0,
			ensure => present,
			password => $::clusterroothash;
	}


}
