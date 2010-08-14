
require 'puppet/provider/parsedfile'

interface = "/etc/network/interfaces"

#XXX XXX XXX XXX
# This provider is in development and not ready for production

# This provider uses the Parsedfile provider to parse the network configuration files
Puppet::Type.type(:network_interface).provide(:debian, :parent => Puppet::Provider::ParsedFile, :default_target => interface, :filetype => :flat) do
	
  desc "Provider for debian network interfaces"
  confine :exists => interface

	confine :operatingsystem => [:debian, :ubuntu]
	defaultfor :operatingsystem => [:debian, :ubuntu]
	commands :ip => "/sbin/ip"
	has_features :manages_userctl
  
  text_line :comment, :match => /^#/
  text_line :blank, :match => /^\s*$/

  # ... change this for interfaces 
  # iface eth0-@map_value
  #   key value
  #   address 192.168.1.1
  #   netmask 255.255.255.0
  #
  #   lines beginning with the work "auto" ~ onboot => yes
  # record_line :parsed, :fields => %w{address netmask gateway broadcast family method},
  
  end
 
