Puppet Network Management Module
================================

Overview
--------

This module provides a type for network device configuration and management

Usage
-----

This is the full specification::

   # network

   network { "local":

   networking => yes | no
   hostname   => exmaple.hostname

   }

  # device configuration
      network_device { "name":
        desc                => "eth0" | "eth1",

  # Basic Configuration
      device                => eth0 | eth1
      bootprto              => none | static | dhcp
      onboot                => yes  | no
      network               => XXX.XXX.XXX.XXX
      netmask               => 255.255.255.0
      ipaddr                => XXX.XXX.XXX.XXX
      userctl               => yes | no
      gateway               => XXX.XXX.XXX.XXX
      hwaddr                => XX:XX:XX:XX:XX:XX
      domain                => example.domain.com
      ensure                => up | down
   }

