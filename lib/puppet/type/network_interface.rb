require 'puppet'

module Puppet

  Puppet::Type.newtype(:network_interface) do
    @doc = "The network managment configuration type"

    ensurable

    # Devices have names
    newparam(:device) do
      isnamevar
      desc "The network device to be configured"
    end
    
    # STATE of the interface
    newproperty(:state) do
      desc "state of the interface"
      newvalues(:up, :down)
    end

    # Broadcast
    newproperty(:broadcast) do
      desc "Configure the broadcast of the device"
    end

    # IPV4 Address
    newproperty(:inet) do
      desc "Configure the IPV4 address of the device"
    end

    # IPV6 Adress
    newproperty(:inet6) do
      desc "Configure the IPV6 address of the device"
    end

    # Gateway
    newproperty(:gateway) do
      desc "Configure the Gateway of the device"
    end

    # Hardware address
    newproperty(:address) do
      desc "Hardware address of the device"
    end

    # Arp
    newproperty(:arp) do
      newvalues(:on, :off)  
    end
  
    # Multicast
    newproperty(:multicast) do
      newvalues(:on, :off)  
    end

    # Dynamic
    newproperty(:dynamic) do
      newvalues(:on, :off)  
    end

    # Dynamic
    newproperty(:txquelen) do
    end
 
    # mtu
    newproperty(:mtu) do
    end
  end
end 
