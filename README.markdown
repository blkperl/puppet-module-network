Puppet Network Management Module
================================

Author: William Van Hevelingen <wvan13@gmail.com>

Overview
--------

This module provides a type for network device configuration and management

Soure code
----------

The source code for this module is available online at
http://github.com/blkperl/puppet-network.git

You can checkout the source code by installing the `git` distributed version
control system and running:

    git clone git://github.com/blkperl/puppet-network.git

Usage
-----

Currently only supports /etc/sysconfig/network-scripts parsing

Example Specs

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

Requires that the ip command is present on the system

  network_interface { "eth0":
    state     => "up",
    mtu       => "1000",
    qlen      => "1500",
    address   => "aa:bb:cc:dd:ee:ff",
    broadcast => "ff:ff:ff:ff:ff:ff",
}

