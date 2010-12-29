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

This is the full specification::

network_config { "eth0":
    bootproto     => none | static | dhcp,
    onboot        => yes  | no,
    network       => "XXX.XXX.XXX.XXX",
    netmask       => "255.255.255.0",
    broadcast     => "XXX.XXX.XXX.XXX",
    ipaddr        => "XXX.XXX.XXX.XXX",
    userctl       => yes | no,
    gateway       => "XXX.XXX.XXX.XXX",
    hwaddr        => "XX:XX:XX:XX:XX:XX",
    domain        => "example.domain.com",
}

Requires that the ip command is present on the system

  network_interface { "eth0":
    state => "up"
}

