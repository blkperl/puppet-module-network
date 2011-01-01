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
    lines = output.split("\n")
    line1 = lines.shift
    line2 = lines.shift
    i=0
    j=0
    p=0
   
    # Magic happens here
    lines.each do |line|
      if line.include?("inet6")
        lines[p] = lines[p] + lines[p+1]
        lines.delete_at(p+1)
      else
        # move along, nothing to see here
      end
       p += 1 
    end

    # Scan the first line of the ip command output
    line1.scan(/\d: (\w+): <(\w+),(\w+),(\w+),?(\w*)> mtu (\d+) qdisc (\w+) state (\w+)\s*\w* (\d+)*/)
    values = {  
      "device"    => $1,
      "mtu"       => $6,
      "qdisc"     => $7,
      "state"     => $8,
      "qlen"      => $9, 
    }
    
    # Scan the second line of the ip command output
    line2.scan(/\s*link\/\w+ ((?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2}) brd ((?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2})/) 
    values["address"]   = $1
    values["broadcast"] = $2 
   
    # Scan all the inet and inet6 entries
    lines.each do |line|
      if line.include?("inet6") 
        line.scan(/\s*inet6 ((?>[0-9,a-f,A-F]*\:{1,2})+[0-9,a-f,A-F]{0,4})\/\w+ scope (\w+)\s*\w*\s*valid_lft (\w+) preferred_lft (\w+)/)
        values["inet6_#{j}"] = { 
          "ip"              => $1,
          "scope"           => $2, 
          "valid_lft"       => $3,
          "preferred_lft"   => $4, 
        }
        j += 1
      else
        line.scan(/\s*inet (\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)\/\d+ b?r?d?\s*(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)?\s*scope (\w+) (\w+:?\d*)/)
        values["inet_#{i}"] = { 
          "ip"         => $1,
          "brd"        => $2,
          "scope"      => $3,
          "dev"        => $4, 
        }
        i += 1
      end
    end
    
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
