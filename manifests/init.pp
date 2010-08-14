
class puppet-network {

	network_interface { "eth0":    
		state     => "up",
		bootproto => "dhcp",
    onboot    => "yes",
		userctl   => "no",
	}

}
