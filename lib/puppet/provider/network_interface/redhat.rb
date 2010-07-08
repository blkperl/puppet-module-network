Puppet::Type.type(:network_interface).provide(:redhat) do
	desc "Provider for redhat network interfaces"

	defaultfor :operatingsystem => [:redhat, :fedora, :centos]

	has_features :manages_userctl

	commands :ip => "/sbin/ip"

	def create
		Puppet.debug "Configuring network %s" % [@resource[:name]]
	end

	def up
		self.device_up
	end

	def down
		self.device_down
	end 

	def absent
		Puppet.debug "Making sure %s is absent " % [@resource[:name]]
		self.device_down
	end

    # Uses the ip command to determine if the device exists
	def exists?
		ip('link', 'list', @resource[:name])
	rescue Puppet::ExecutionFailure
		raise Puppet::Error, "Network interface %s does not exist" % @resource[:name] 
	end 

	# Parses the ip command for the word UP 
	def is_up?
		lines = ip('link', 'list', @resource[:name])
		return lines.include?("UP")
	end

	# up | down | absent
	def status
		if exists?
  			if is_up?
				Puppet.debug "%s state is up " % [@resource[:name]]
				return "up"
  			else
				Puppet.debug "%s state is down " % [@resource[:name]]
				return "down"
  			end 
		else
  			Puppet.debug "%s is absent " % [@resource[:name]]
  			return "absent"
		end
	end

	# Two cases, device down, device already up
	def device_up
		if status == "down"
			ip('link', 'set', @resource[:name], 'up')
			Puppet.debug "Bringing %s up" % [@resource[:name]]
		else
			Puppet.debug " %s is already up" % [@resource[:name]]
		end
	end

	# Two cases, device up, device already down
	def device_down
		if status == "up"
			ip('link', 'set', @resource[:name], 'down')
			Puppet.debug "Bringing %s down" % [@resource[:name]]
		else
			Puppet.debug "%s is already down" % [@resource[:name]]
		end
	end
	
	# Checks state of the config file
	def generate_config_hash
		file = "/etc/sysconfig/network-scripts/ifcfg-#{@resource[:name]}"
		config_hash = {}
		if File.exist?(file)
			lines = File.new(file, 'r').readlines
			
			lines.each do |line|
				config_hash[lines.split('=')[0].strip] = line.split('=')[1].strip } 
			end
		
			@resource.merge(config_hash)
			
			if (@resource == config_hash)
				Puppet.debug "Config file is in sync"
			else
				Puppet.debug "Config file in not in sync"
				self.write_config_hash(@resource, file)
			end
		else
			Puppet.debug "Puppet was looking for " + file + " and coundn't find it"
			raise Puppet::Error, "Puppet can't find %s config file" % @resource[:name]
		end
	end

	# Dumps the interface's config file
	def write_config_hash(config_hash, filename)
		config_file = File.new(filename, 'w')
		hash.each_pair{ |key, value| config_file.write(key + value.nil? ? '=' + value : "") } 
	end

end


