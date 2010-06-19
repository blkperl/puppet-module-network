Puppet::Type.newtype(:network) do
    
    desc "The network managment configuration type"

    ensurable do
     
      newparam(:device) do
       
      desc "The network device to be configured"
	
       validate do |value|
            unless value =~ /^\w+/
              raise ArguementError, %s is not a valid device name" % value
       	    end
       end
    end

end
