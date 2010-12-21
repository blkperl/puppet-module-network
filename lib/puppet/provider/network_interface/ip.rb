Puppet::Type.type(:network_interface).provide(:ip) do

  # ip command is preferred over ifconfig
  commands :ip => "/sbin/ip"

  # Uses the ip command to determine if the device exists
  def exists?
    ip('link', 'list', @resource[:name])
  rescue Puppet::ExecutionFailure
     raise Puppet::Error, "Network interface %s does not exist" % @resource[:name] 
  end 
  
  def device
    config_values[:dev]
  end
  
  # Ensurable/ensure adds unnecessary complexity to this provider
  # Network interfaces are up or down, present/absent are unnecessary
  def state
    lines = ip('link', 'list', @resource[:name])
    if lines.include?("UP")
      return "up"
    else
      return "down"
    end 
  end

  # Set the interface's state
  # Facter bug #2211 prevents puppet from bringing up network devices
  def state=(value)
    ip('link', 'set', @resource[:name], value)
  end

  def state_values
    @values ||= read_ip_ouput
  end

  def read_ip_ouput
    output = ip('link', 'show', @resource[:name])
    puts output
  end

  IP_ARGS = [ :arp, :multicast, :dynamic, :txquelen, :mtu, :address, :broadcast ]
  
  IP_ARGS.each do |ip_arg|
    define_method(ip_arg.to_s.downcase) do
      state_values[ip_arg]
    end
    
    define_method("#{ip_arg}=".downcase) do |value|
      ip('link', 'set', @resource[:name], "#{ip_arg}", value)
      state_values[ip_arg] = value
    end
  end

end
