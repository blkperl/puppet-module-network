Puppet::Type.type(:network_interface).provide(:debian) do
	desc "Provider for debian network interfaces"

	confine :operatingsystem => [:debian, :ubuntu]
	defaultfor :operatingsystem => [:debian, :ubuntu]

	has_features :manages_userctl
	@modified = false
	Config_file = "/etc/network/interfaces"
	commands :ip => "/sbin/ip"

	# Manages the config file
	def create
		Puppet.debug "Configuring %s " % [@resource[:name]]
	end

	#Ensures state is up & device is configured
	def up
		self.device_up 
	end

	#Ensures state is down & device is configured
	def down
		self.device_down
	end 

	# Ensures puppet ignores this network interface
	def absent
		Puppet.debug "Making sure %s is absent " % [@resource[:name]]
	end

	# Uses the ip command to determine if the device exists
	def exists?
		ip('link', 'list',  @resource[:name])
	rescue Puppet::ExecutionFailure
		raise Puppet::Error, "Network interface %s does not exist" % @resource[:name]
	end 

    # Parses the ip command for the word UP
	def is_up?
		lines = ip('link', 'list', @resource[:name])
		return lines.include?("UP")
	end

	# present | up | down | absent
	def status
		if exists?
			if @resource[:ensure].to_s == "present" && @modified == false
				Puppet.debug "%s state is present" % [@resource[:name]]
				return "present"
			elsif @resource[:ensure].to_s == "absent"
  				Puppet.debug "%s is absent " % [@resource[:name]]
  				return "absent"
			else
				if is_up?
					Puppet.debug "%s state is up " % [@resource[:name]]
					return "up"
				else
					Puppet.debug "%s state is down " % [@resource[:name]]
					return "down"
				end
			end 
		else
  			Puppet.debug "%s is absent " % [@resource[:name]]
  			return "absent"
		end
	end

	# Two cases device down, device already up
	def device_up
		if status == "down"
			ip('link', 'set', @resource[:name], 'up')
			Puppet.debug "Bringing %s up " % [@resource[:name]]
		else
			Puppet.debug "%s is already up" % [@resource[:name]]
		end
	end

	# Two cases, device up, device already down
	def device_down
		if status == "up"
			ip('link', 'set', @resource[:name], 'down')
			Puppet.debug "Bringing %s down " % [@resource[:name]]
		else
			Puppet.debug "%s is already down" % [@resource[:name]]
		end
	end
	
	# Current values in the config file
	def current_values
		@values ||= read_config
	end

	def bootproto
		current_values[:bootproto]
	end

	def bootproto=(value)
		current_values[:bootproto] = value
		@modified = true
	end

	def onboot
		current_values[:onboot]
	end

	def onboot=(value)
		current_values[:onboot] = value
		@modified = true
	end

	def netmask
		current_values[:netmask]
	end

	def netmask=(value)
		current_values[:netmask] = value
	end

	def network
		current_values[:network]
	end

	def network=(value)
		current_values[:network] = value
		@modified = true
	end

	def broadcast
		current_values[:broadcast]
	end

	def broadcast=(value)
		current_values[:broadcast] = value
		@modified = true
	end

	def ipaddr
		current_values[:ipaddr]
	end

	def ipaddr=(value)
		current_values[:ipaddr] = value
	end

	def gateway
		current_values[:gateway]
	end

	def gateway=(value)
		current_values[:gateway] = value
		@modified = true
	end

	def hwaddr
		current_values[:hwaddr]
	end

	def hwaddr=(value)
		current_values[:hwaddr] = value
		@modified = true
	end

	def userctl
		current_values[:usrctl]
	end

	def userctl=(value)
		current_values[:usrctl] = value
		@modified = true
	end

	# Gathers the content in the config file and returns a hash of keys & values
	def read_config
		config_hash = {}
		if File.exists?(Config_file)
			lines = File.new(Config_file, 'r').readlines
			
			# Debian base network interface files uses the format: key, value
			lines.each do |line|
				# Code that the parses the file
			end
			Puppet.debug "Imported config file into to a hash"
			return config_hash
		else
			# FIXME puppet could create the file if nil?	
			Puppet.debug "Puppet was loking for " + Config_file + "and coundn't find it"
			raise Puppet::Error, "Puppet can't find the config file for %s" % @resource[:name]
			return nil
		end
	end

	# Writes to the config file if @modified is true
	def write_config
		if @modified = true
			config_file = File.new(Config_file, 'w')
			# FIXME add write to file code
			Puppet.debug "Wrote to #{Config_file}"
		else
			Puppet.debug "Config file is in sync"
		end
	end

end
