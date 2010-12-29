require 'puppet'

module Puppet

  Puppet::Type.newtype(:network_config) do
    @doc = "The network configuration type"

    ensurable

    newparam(:device) do
      isnamevar
      desc "The network device to be configured"
    end

    newproperty(:bootproto) do
      desc "Boot priority for the network device"
      newvalues(:dhcp, :static, :none)
      defaultto(:dhcp)
    end

    newproperty(:onboot) do
      desc "Start the network device on boot" 
      newvalues(:yes, :no)
      defaultto(:yes)
    end

    newproperty(:netmask) do
      desc "Configure the netmask of the device"
    end

    newproperty(:network) do
      desc "Configure the network of the device"
    end

    newproperty(:broadcast) do
      desc "Configure the broadcast of the device"
    end

    newproperty(:ipaddr) do
      desc "Configure the IP address of the device"
    end

    newproperty(:gateway) do
      desc "Configure the Gateway of the device"
    end

    newproperty(:hwaddr) do
      desc "Hardware address of the device"
    end

    newproperty(:domain) do
      desc "Configure the domain of the device"
    end

    newproperty(:userctl, :required_features => :manages_userctl) do
      desc "Non root users are allowed to control device if set to yes"
      newvalues(:yes, :no)
      defaultto(:no)
    end

  end

end 
