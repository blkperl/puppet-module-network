Puppet::Type.type(:network).provide(:redhat) do
   desc "Provider for redhat network interfaces"

   defaultfor :operatingsystem => [:redhat, :fedora, :centos]

   # Parses the config file, sync's the state
   def create

   end

   # Parses the config file, syncs the state, ensure => up
   def up
   end

   def down
   end

   def absent
   end


end
