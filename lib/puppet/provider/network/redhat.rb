Puppet::Type.type(:network).provide(:redhat) do
	desc "Provider for redhat network interfaces"

	defaultfor :operatingsystem => [:redhat, :fedora, :centos]

	has_features :manages_userctl

	commands :ip => "/sbin/ip"

	def create
		Puppet.debug "Configuring network %s" % [@resource[:name]]
		self.device_up
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

	def exists?
		ip('link', 'list', @resource[:name])
	rescue Puppet::ExecutionFailure
		raise Puppet::Error, "Network interface #{@resource[:name]} does not exist" 
	end 

	# FIXME 
	# Either parse the config file or use a command's output
	def state
		return true
	end

	# up | down | absent
	def status
		if exists?
  			if state
				Puppet.debug "%s state is UP " % [@resource[:name]]
				return "UP"
  			else
				Puppet.debug "%s state is DOWN " % [@resource[:name]]
				return "DOWN"
  			end 
		else
  			Puppet.debug "%s is absent " % [@resource[:name]]
  			return "absent"
		end
	end

	# Two cases, device down, device already up
	def device_up
		if status == "DOWN"
			ip('link', 'set', @resource[:name], 'up')
			Puppet.debug "Bringing %s up" % [@resource[:name]]
		else
			Puppet.debug " %s is already up" % [@resource[:name]]
		end
	end

	# Two cases, device up, device already down
	def device_down
		if status == "UP"
			ip('link', 'set', @resource[:name], 'down')
			Puppet.debug "Bringing %s down" % [@resource[:name]]
		else
			Puppet.debug "%s is already down" % [@resource[:name]]
		end
	end

end


