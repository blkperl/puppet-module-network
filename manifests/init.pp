
class puppet-network {

	network_interface { "eth0":    
		state => "up",
		bootproto => "dhcp",
		ipaddr => "127.0.0.1",
		userctl => "no",
	}

}
