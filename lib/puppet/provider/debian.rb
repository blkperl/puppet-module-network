Puppet::Type.type(:network).provide(:debian) do
   desc "Provider for debian network interfaces"

   defaultfor :operatingsystem => [:debian, :ubuntu]

   def create
   end
 
   def up
   end
 
   def down
   end 

   def absent
   end



end
