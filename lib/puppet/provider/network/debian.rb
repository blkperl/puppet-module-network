Puppet::Type.type(:network).provide(:debian) do
   desc "Provider for debian network interfaces"

   defaultfor :operatingsystem => [:debian, :ubuntu]
   
   has_features :manages_userctl

   commands :ifconfig => "/sbin/ifconfig"
   commands :ip => "/sbin/ip"
   
   def create
     Puppet.debug "Configuring %s " % [@resource[:name]]
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

   # FIXME - need to parse a command or config file 
   def exists?
     return true 
   end 
   
   # FIXME - need to parse a command or config file
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
          return "ABSENT"
       end

   end
   
   # Bring network interface up
   # TODO catch exceptions
   def device_up
     if status == "DOWN"
       ip "link set"[@resource[:name]] "up"
       Puppet.debug "Bringing %s up " % [@resource[:name]]
     else
       Puppet.debug "%s is already up" % [@resource[:name]]
     end
   end

   # Bring network interface down
   # TODO catch exceptions
   def device_down
     if status == "UP"
       ip "link set" [@resource[:name]] "down"
       Puppet.debug "Bringing %s down " % [@resource[:name]]
     else
       Puppet.debug "%s is already down" % [@resource[:name]]
     end
   end

end
