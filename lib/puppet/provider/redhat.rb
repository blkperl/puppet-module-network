Puppet::Type.type(:network).provide(:redhat) do
   desc "Provider for redhat network interfaces"

   defaultfor :operatingsystem => [:redhat, :fedora, :centos]

   def create
     Puppet.debug "Configuring network interface " % [@resource[:name]]
   end
 
   def up
     Puppet.debug "Bringing network interface up " % [@resource[:name]]
     
   end
 
   def down
     Puppet.debug "Bringing network interface down " % [@resource[:name]]
   end 

   def absent
     Puppet.debug "Making sure network interface is absent " % [@resource[:name]]
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
  

end
