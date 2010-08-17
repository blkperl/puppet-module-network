Puppet::Type.type(:network_interface).provide(:redhat) do
	desc "Provider for redhat network interfaces"

  # For this provider puppet will use commands to configure the interface and
  # modify the configuration file so that the device is still configured on boot

	confine :operatingsystem => [:redhat, :fedora, :centos]
	defaultfor :operatingsystem => [:redhat, :fedora, :centos]

	has_features :manages_userctl
	
	@modified = false

  # ip command is preferred over ifconfig
	commands :ip => "/sbin/ip"

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

  # Uses the ip command to determine if the device exists
	def exists?
    @config_file = "/etc/sysconfig/network-scripts/ifcfg-#{@resource[:name]}"
  	ip('link', 'list', @resource[:name])
	rescue Puppet::ExecutionFailure
	 	raise Puppet::Error, "Network interface %s does not exist" % @resource[:name] 
	end 

	# Current values in /proc	
	def current_values
		@values ||= read_ip
	end
	
	# Current values in the config file	
  def config_values
		@values ||= read_config
	end

  def device
    config_values[:DEVICE]
  end
  
  CONFIG_KEYS = [ :BOOTPROTO, :ONBOOT, :NETMASK, :NETWORK, :BROADCAST, :IPADDR, 
                  :GATEWAY, :HWADDR, :DOMAIN, :USRCTL ]
  
  CONFIG_KEYS.each do |config_key|
    define_method(config_key.to_s.downcase) do
      config_values[config_key]
    end
    
    define_method("#{config_key}=".downcase) do |value|
      config_values[config_key] = value
  		@modified = true
    end
  end

  # Gets the current status of networking by parsing /proc
  # FIXME Not implemented yet
  def read_proc
  end

	# Gathers the content in the config file and returns a hash of keys & values
	# FIXME I eat comments for fun
  def read_config
    config_hash = {}
		if File.exist?(@config_file.to_s)
			lines = File.new(@config_file.to_s, 'r').readlines

			# Redhat based config files use the format: KEY=value
			lines.select {|l| l =~ /=/ }.each do |line|
				key = line.split('=')[0].chomp
				  config_hash[key.upcase.to_sym] = line.split('=')[1].chomp
			end
			
			Puppet.debug "Imported config file to a hash"
			return config_hash
		else
			# TODO Puppet could create the file if nil?
			Puppet.debug "Puppet was looking for #{@config_file.to_s} and coundn't find it"
			raise Puppet::Error, "Puppet can't find the config file for %s" % @resource[:name]
			return nil
		end
	end
  
	# Writes to the config file if @modified is true
	# Doesn't modify the config file if :noconfig is set to true
	def flush
		#if @resouce[:noconfig] == false
      if @modified == true
	  		file = File.new(@config_file.to_s, 'w')
		  	@values.each_pair{ |key, value| file.write(value.nil? ? "#{key}\n" : "#{key}=#{value}\n") } 
			  Puppet.debug "Flushed config values to  #{@config_file.to_s}"
		  else 
			  Puppet.debug "Config file does not need to be modified"
		  end
   # else
      #Puppet.debug ":noconfig set to %s, not modifing config file" % @resource[:noconfig]
   # end
  end

end # End of redhat provider
