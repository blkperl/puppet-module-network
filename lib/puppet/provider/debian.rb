Puppet::Type.type(:network).provide(:debian) do
   desc "Provider for debian network interfaces"

   defaultfor :operatingsystem => [:debian, :ubuntu]

end
