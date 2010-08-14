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
    require 'pp'
    pp @values
    return @values
	end

	def bootproto
		config_values[:BOOTPROTO]
	end

	def bootproto=(value)
		config_values[:BOOTPROTO] = value
		@modified = true
	end
        
	def onboot
    config_values[:ONBOOT]
	end
	
	def onboot=(value)
		config_values[:ONBOOT] = value
		@modified = true
	end

	def netmask
		config_values[:NETMASK]
	end

	def netmask=(value)
		config_values[:NETMASK] = value
		@modified = true
	end

	def network
		config_values[:NETWORK]
	end

	def network=(value)
		config_values[:NETWORK] = value
		@modified = true
	end

	def broadcast
		config_values[:BROADCAST]
	end

	def broadcast=(value)
		config_values[:BROADCAST] = value
		@modified = true
	end

	def ipaddr
		config_values[:IPADDR]
	end

	def ipaddr=(value)
		config_values[:IPADDR] = value
		@modified = true
	end

	def gateway
		config_values[:GATEWAY]
	end

	def gateway=(value)
		config_values[:GATEWAY] = value
		@modified = true
	end

	def hwaddr
		config_values[:HWADDR]
	end

	def hwaddr=(value)
		config_values[:HWADDR] = value
		@modified = true
	end

  def domain
    config_values[:DOMAIN]
  end

  def domain=(value)
    config_values[:DOMAIN] = value
  end

	def userctl
		config_values[:USRCTL]
	end

	def userctl=(value)
		config_values[:USRCTL] = value
		@modified = true
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
