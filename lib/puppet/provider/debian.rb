Puppet::Type.type(:network).provide(:debian) do
   desc "Provider for debian network interfaces"

   defaultfor :operatingsystem => [:debian, :ubuntu]
   
   has_features :manages_userctl

   commands :ifconfig => "/sbin/ifconfig -a"
   commands :ip => "/sbin/ip link ls"
   
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

   # FIXME - need to grep ip link ls [@resource[:name]]
   def exists?
     return true 
   end 
   
   # FIXME - need to grep ifconfig -a
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
   
   # Bring network interface up
   # TODO catch excpetions
   def device_up
     if status == "UP"
       ip [@resource[:name]] "up"
       Puppet.debug "Bringing network interface up " % [@resource[:name]]
     else
       Puppet.debug "Network interface is already down" % [@resource[:name]]
     end
   end

   # Bring network interface down
   # TODO catch exceptions
   def device_down
     if status == "UP"
       ip [@resource[:name]] "down"
       Puppet.debug "Bringing network interface down " % [@resource[:name]]
     else
       Puppet.debug "Network interface is already down" % [@resource[:name]]
     end
   end

end
