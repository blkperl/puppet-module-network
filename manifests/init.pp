
class puppet-network {

	network_interface { "eth0":    
		ensure => down,
	}


}
