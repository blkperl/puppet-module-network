require 'puppet'

module Puppet

  Puppet::Type.newtype(:network_interface) do
    @doc = "The network managment configuration type"

    ensurable

    newparam(:device) do
      isnamevar
      desc "The network device to be configured"
    end
    
    newproperty(:state) do
      desc "state of the interface"
      newvalues(:up, :down)
    end

    newproperty(:broadcast) do
      desc "Configure the broadcast of the device"
    end

    newproperty(:inet) do
      desc "Configure the IPV4 address of the device"
    end

    newproperty(:inet6) do
      desc "Configure the IPV6 address of the device"
    end

    newproperty(:gateway) do
      desc "Configure the Gateway of the device"
    end

    newproperty(:address) do
      desc "Hardware address of the device"
    end

    newproperty(:arp) do
       desc "Arp"
       newvalues(:on, :off)  
    end
  
    newproperty(:multicast) do
      desc "multicast"
      newvalues(:on, :off)  
    end

    newproperty(:dynamic) do
      desc "dynamic"
      newvalues(:on, :off)  
    end

    newproperty(:qlen) do
      desc "txquelen"
    end
 
    newproperty(:mtu) do
      desc "mtu"
    end
  end
end 
