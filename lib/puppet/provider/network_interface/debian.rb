Puppet::Type.type(:network_interface).provide(:debian) do
	desc "Provider for debian network interfaces"

	defaultfor :operatingsystem => [:debian, :ubuntu]

	has_features :manages_userctl

	commands :ip => "/sbin/ip"

	def create
		Puppet.debug "Configuring %s " % [@resource[:name]]
	end

	def up
		self.device_up 
	end

	def down
		self.device_down
	end 

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

	# up | down | absent
	def status
		if exists?
			if @resource[:ensure].to_s == "present"
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

	#Parses the interface's config file
	def parse_config_file

	end

end
