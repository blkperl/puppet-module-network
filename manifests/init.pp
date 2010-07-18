
class puppet-network {

	network_interface { "eth0":    
		ensure => present,
		bootproto => static,
		userctl => yes,
	}


}
