Puppet::Type.type(:network_interface).provide(:debian) do
	desc "Provider for debian network interfaces"

	confine :operatingsystem => [:debian, :ubuntu]
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
	
	def read_config
	
	end
	
	def write_config
	
	end

end
