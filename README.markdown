Puppet Network Management Module
================================

Authors: William Van Hevelingen <wvan13@gmail.com>
         Elie Bleton <ebleton@heliostech.fr>
	 Camille Meulien <cmeulien@heliostech.fr>

Overview
--------

This module provides types for network device configuration and management

Soure code
----------

The source code for this module is available online at
http://github.com/heliostech/puppet-network.git

You can checkout the source code by installing the `git` distributed version
control system and running:

    git clone git://github.com/heliostech/puppet-network.git

Usage
-----

Only redhat-like (RHEL,Fedora,CentOS) are currently supported.

The `network_config` type is used to maintain `/etc/sysconfig/network-scripts/ifcfg-*` files :

network_config { "eth0":
    bootproto     => "dhcp",
    onboot        => "yes",
    netmask       => "255.255.255.0",
    broadcast     => "192.168.56.255",
    ipaddr        => "192.168.56.101",
    userctl       => "no",
    hwaddr        => "08:00:27:34:05:15",
    domain        => "example.domain.com",
}

It has preliminary support for bridges and vlan attributes, configured as usual on redhat (samples could be eventually provided - mail heliostech if you actually need some).

The `network_interface` maintains live state of the interface using the `ip` tool, likewise :

network_interface { "eth0":
    state     => "up",
    mtu       => "1000",
    qlen      => "1500",
    address   => "aa:bb:cc:dd:ee:ff",
    broadcast => "ff:ff:ff:ff:ff:ff",
}

Note: `network_interface` and `network_config` types are not dependant on each other in any way. `network_interface` is experimental.