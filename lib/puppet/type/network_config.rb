require 'puppet'

module Puppet

  Puppet::Type.newtype(:network_config) do
    @doc = "The network configuration type"

    ensurable

    feature :manages_userctl, "When users can ifup/ifdown network devices."

    newparam(:device) do
      isnamevar
      desc "The network device to be configured"
    end

    newparam(:bootproto) do
      desc "Boot priority for the network device"
      newvalues(:dhcp, :static, :none)
      defaultto(:dhcp)
    end

    newparam(:onboot) do
      desc "Start the network device on boot" 
      newvalues(:yes, :no)
      defaultto(:yes)
    end

    newparam(:netmask) do
      desc "Configure the netmask of the device"
    end

    newparam(:network) do
      desc "Configure the network of the device"
    end

    newparam(:broadcast) do
      desc "Configure the broadcast of the device"
    end

    newparam(:ipaddr) do
      desc "Configure the IP address of the device"
    end

    newparam(:gateway) do
      desc "Configure the Gateway of the device"
    end

    newparam(:hwaddr) do
      desc "Hardware address of the device"
    end

    newparam(:domain) do
      desc "Configure the domain of the device"
    end

    newparam(:bridge) do
      desc "The bridge in which the device is enslaved (if any)"
    end

    newparam(:type) do
      desc "Type of the device"
      newvalues(:ethernet, :bridge)
      defaultto(:ethernet)
    end

    # XXX
    newparam(:userctl, :required_features => :manages_userctl) do
      desc "Non root users are allowed to control device if set to yes"
      newvalues(:yes, :no)
      defaultto(:no)
    end

  end

end 
