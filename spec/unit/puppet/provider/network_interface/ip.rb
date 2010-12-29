require 'puppet'
require 'ruby-debug'
require 'mocha'
require '/etc/puppet/modules/puppet-network/lib/puppet/provider/network_interface/ip.rb'


provider_class = Puppet::Type.type(:network_interface).provider(:ip)

describe provider_class do
  before do
    @resource = stub("resource", :name => "eth0")
    @resource.stubs(:[]).with(:name).returns "eth0"
    @resource.stubs(:[]).returns "eth0"
    @provider = provider_class.new(@resource) 
  end
  
  it "should parse ip link show output with ipv6" do
    ip_output = <<-HEREDOC
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:6c:c7:59 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.101/24 brd 192.168.56.255 scope global eth0
    inet6 fe80::a00:27ff:fe6c:c759/64 scope link 
       valid_lft forever preferred_lft forever
HEREDOC

    @provider.stubs(:ip_output).returns(ip_output)
    @provider.read_ip_output.should == {
      "device"      => "eth0",
      #"dynamic"    => "on",
      #"multicast"  => "on",
      #"arp"        => "on",
      "mtu"         => "1500",
      "qdisc"       => "pfifo_fast",
      "state"       => "UP",
      "qlen"        => "1000",
      "address"     => "08:00:27:6c:c7:59",
      "broadcast"   => "ff:ff:ff:ff:ff:ff",
      "inet"        => "192.168.56.101/24",
      "inet_brd"    => "192.168.56.255",
      "inet_scope"  => "global",
      "inet_dev"    => "eth0",
      "inet6"       => "fe80::a00:27ff:fe6c:c759/64",
      "inet6_scope" => "link",
      "valid_lft"   => "forever",
      "preferred_lft" => "forever"
    }
    
  end


end
