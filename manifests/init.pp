
class puppet-network {

  network_config { "eth3":
    bootproto => "dhcp",
    onboot    => no,
    userctl   => yes,
  }

  network_interface { "eth0":
    state => "up",
  }

}
