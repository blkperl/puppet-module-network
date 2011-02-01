Puppet::Type.type(:network_config).provide(:network_scripts) do
  desc "Provider for configuration of network_scripts"

  defaultfor :operatingsystem => [:redhat, :fedora, :centos]

  has_features :manages_userctl

  @modified = false

  # ip command is preferred over ifconfig
  commands :ip => "/sbin/ip"

  # Uses the ip command to determine if the device exists
  def exists?
    @config_file = "/etc/sysconfig/network-scripts/ifcfg-#{@resource[:name]}"
    ip('link', 'list', @resource[:name])
  rescue Puppet::ExecutionFailure
     raise Puppet::Error, "Network interface %s does not exist" % @resource[:name] 
  end 

  # Current values in the config file
  def config_values
    @values ||= read_config
  end

  def device
    config_values[:DEVICE]
  end
  
  CONFIG_KEYS = [ :BOOTPROTO, :ONBOOT, :NETMASK, :NETWORK, :BROADCAST, :IPADDR, 
                  :GATEWAY, :HWADDR, :DOMAIN, :USRCTL ]
  
  CONFIG_KEYS.each do |config_key|
    define_method(config_key.to_s.downcase) do
      config_values[config_key]
    end
    
  define_method("#{config_key}=".downcase) do |value|
      config_values[config_key] = value
      @modified = true
    end
  end

  # Reads the content in the config file and returns a hash of keys & values
  def read_config
    config_hash = {}
    if File.exist?(@config_file.to_s)
      lines = File.new(@config_file.to_s, 'r').readlines

      lines.select {|l| l =~ /=/ }.each do |line|
        key = line.split('=')[0].chomp
          config_hash[key.upcase.to_sym] = line.split('=')[1].chomp
      end
      
      Puppet.debug "Imported config file to a hash"
      return config_hash
    else
      Puppet.debug "Puppet was looking for #{@config_file.to_s} and coundn't find it"
      raise Puppet::Error, "Puppet can't find the config file for %s" % @resource[:name]
      return nil
    end
  end
  
  # Writes to the config file if @modified is true
  def flush
    if @modified == true
      File.open(@config_file.to_s, 'w') do |file|
        @values.each_pair { |key, value|
          file.write(value.nil? ? "#{key}\n" : "#{key}=#{value}\n")
        }
        Puppet.debug "Flushed config values to  #{@config_file.to_s}"
      end
    else
      Puppet.debug "Config file does not need to be modified"
    end
  end
end
