
class network-example {

  network_config { "eth0":
    bootproto  => dhcp,
    onboot     => yes,
    netmask    => "255.255.255.0",
    broadcast  => "131.252.223.63",
    ipaddr     => "131.202.211.211",
    gateway    => "121.211.213.245",
    hwaddr     => "AA:BB:CC:DD:FF",
    userctl    => no,
    domain     => "example.domain.com",
  }

  network_config { "eth1":
    bootproto => static,
    onboot    => no,
    netmask   => "255.255.255.0",
    broadcast => "131.252.223.63",
    ipaddr    => "131.252.214.173",
    gateway   => "121.411.713.245",
    hwaddr    => "FF:DD:CC:BB:AA",
    userctl   => yes,
    domain    => "example2.domain.com"
  }
  
  network_interface { "eth3":
    state     => "up",
    mtu       => "1111",
    qlen      => "2000",
    address   => "aa:bb:cc:dd:ee:ff",
    broadcast => "ff:ff:ff:ff:ff:ff",
  }

}
