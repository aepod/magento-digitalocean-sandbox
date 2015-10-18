class nfs::client ( ) inherits nfs {

	file {
		"$::sharedstoragetarget":
			ensure => directory,
			owner => "$::wwwuid",
			group => "$::wwwuid",
			require => Service["rpcbind"];
	}

	service {
		"rpcbind":
			ensure => running,
			enable => true,
			require => Package["nfs-utils"];
		"nfslock":
			ensure => running,
			enable => true,
			require => Service["rpcbind"];
	}

	mount {
		"$::sharedstoragetarget":
			ensure => "mounted",
			device => "db:/shared/",
			fstype => "nfs",
			options => "vers=3,proto=tcp,hard,intr,rsize=32768,wsize=32768,noatime,_netdev",
			atboot => true,
			require => [ File["$::sharedstoragetarget"], Host["db"] ];
	}
	
}
