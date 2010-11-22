
class puppet-network {

  network_config { "eth3":
    state     => "up",
    bootproto => "dhcp",
    onboot    => "yes",
    userctl   => "no",
  }

}
