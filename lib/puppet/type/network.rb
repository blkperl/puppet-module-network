Puppet::Type.newtype(:network) do
    desc "The network managment configuration type"

    # Ensure
     ensurable do

     newvalue(:present, :up, :down, :absent)     
    
      # Devices have names
      newparam(:device) do
       desc "The network device to be configured"
         validate do |value|
           unless value =~ /^\w+/
            raise ArguementError, "%s is not a valid device name" % value
       	 end
      end
    end

     # Boot Prioty should default to dhcp
     newproperty(:bootprto) do
	desc "Boot priority for the network device"
        newvalue(:dhcp, :static, :none)
	defaultto(:dhcp)     
     end

     # Start device on boot
     newparam(:onboot) do
      desc "Start the network device on boot" 
      newvalue(:yes, :no)
      defaultto :yes
     end
end 
