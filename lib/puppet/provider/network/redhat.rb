Puppet::Type.type(:network).provide(:redhat) do
   desc "Provider for redhat network interfaces"

   defaultfor :operatingsystem => [:redhat, :fedora, :centos]
 
   has_features :manages_userctl

   commands :ip => "/sbin/ip"

   def create
     Puppet.debug "Configuring network interface " % [@resource[:name]]
     self.device_up
   end
 
   def up
     self.device_up
   end
 
   def down
     self.device_down
   end 

   def absent
     Puppet.debug "Making sure network interface is absent " % [@resource[:name]]
     self.device_down
   end

   # FIXME - Use a command or validate existence of config file or both
   def exists?
     return true 
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
            Puppet.debug "Interface state is UP " %s [@resource[:name]]
            return "UP"
          else
            Puppet.debug "Interface state is DOWN " %s [@resource[:name]]
            return "DOWN"
          end 
       else
          Puppet.debug "Interface is absent " %s [@resource[:name]]
          return "absent"
       end

   end
  
   # TODO catch exceptions
   def device_up
     if status == "DOWN"
       ip "link set" [@resource[:name]] "up"
       Puppet.debug "Bringing network interface up" %s [@resource[:name]]
     else
       Puppet.debug "The network interface is already up" %s [@resource[:name]]
     end
   end

   # TODO catch exceptions
   def device_down
     if status == "UP"
       ip "link set" [@resource[:name]] "down"
       Puppet.debug "Bringing network interface down" %s [@resource[:name]]
     else
       Puppet.debug "The network interface is already down" %s [@resource[:name]]
     end
   end

end


