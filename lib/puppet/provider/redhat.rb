Puppet::Type.type(:network).provide(:redhat) do
   desc "Provider for redhat network interfaces"

   defaultfor :operatingsystem => [:redhat, :fedora, :centos]

end
