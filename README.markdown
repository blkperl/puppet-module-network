Puppet Network Management Module
================================

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

This is the full specification::

   # network

   network { "default":

   networking => yes | no			     #default is yes
   hostname   => example.hostname

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
      ensure                => present | up | down | absent  
   }

  # ensure => up, implies onboot => yes
  # ensure => down, implies onboot => no

TODO
----
Add support for wireless interfaces
Add support for static routes
Add support for vlan tagging
Add support for bridging
