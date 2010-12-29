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
    @values ||= read_ip_output
  end

  def ip_output
    ip('addr','show', 'dev', @resource[:name])
  end

  # FIXME Back Named Reference Captures are supported in Ruby 1.9.x
  def read_ip_output
    output = ip_output
    ip_regex = Regexp.new('\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
    ipv6_regex = Regexp.new('(?>[0-9,a-f,A-F]*\:{1,2})+[0-9,a-f,A-F]{0,4}\/\w+')
    mac_regex  = Regexp.new('(?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2}')
    lines = output.split("\n")
    
    values = {}
    lines[0].scan(/\d: (\w+): <(\w+),(\w+),(\w+),(\w+)> mtu (\d+) qdisc (\w+) state (\w+) qlen (\d+)/)
    line0 = { "device"          => $1,
              "mtu"             => $6,
              "qdisc"           => $7,
              "state"           => $8,
              "qlen"            => $9, }
    values.update(line0)
    
    lines[1].scan(/\s*link\/ether ((?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2}) brd ((?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2})/)
    line1 = { "address"         => $1,
              "broadcast"       => $2, }
    values.update(line1)
    
    lines[2].scan(/\s*inet (\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b\/\d+) brd (\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b) scope (\w+) (\w+)/)
    line2 = { "inet"            => $1,
              "inet_brd"        => $2,
              "inet_scope"      => $3,
              "inet_dev"        => $4, }
    values.update(line2)
    
    lines[3].scan(/\s*inet6 ((?>[0-9,a-f,A-F]*\:{1,2})+[0-9,a-f,A-F]{0,4}\/\w+) scope (\w+)/) 
    line3 = { "inet6"           => $1,
              "inet6_scope"     => $2, }
    values.update(line3)
    
    lines[4].scan(/\s*valid_lft (\w+) preferred_lft (\w+)/)
    line4 = { "valid_lft"       => $1,
              "preferred_lft"   => $2, }
    values.update(line4)
    
    return values

  end

  IP_ARGS = [ :arp, :multicast, :dynamic, :txquelen, :mtu, :address, :broadcast ]
  
  IP_ARGS.each do |ip_arg|
    define_method(ip_arg.to_s.downcase) do
      state_values[ip_arg]
    end
    
    define_method("#{ip_arg}=".downcase) do |value|
      ip('link', 'set', 'dev', @resource[:name], "#{ip_arg}", value)
      state_values[ip_arg] = value
    end
  end

end
