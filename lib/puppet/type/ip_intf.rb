Puppet::Type.newtype(:ip_intf) do
 desc ' = {
	    Manage Vlan_intf on Lenovo cnos.

	    Example:
	     ip_intf {"<if_name>":
	     bridge_port => yes/no,
	     mtu => "<mtu>",
             ip_addr => "<ip_addr>",
             ip_prefix_len => "<ip_prefix_len>",
             vrf_name => "<vrf_name>",
             vlans => "<admin_state>"   
       	    }
          }'
 #Parameters
 newparam(:if_name, namevar: true) do
  desc 'Ethernet interface name'
 end

 newparam(:vrf_name) do
  desc 'string 32 characters long'
 end
 
 #Properties 
 newproperty(:bridge_port) do
  newvalues(:yes, :no)
  desc 'one of yes/no'
 end 
 
 newproperty(:mtu) do
  desc 'integer from 64-9216'
  
  munge do |value|
        value.to_i
  end
  
  validate do |value|
	unless value.to_i.between?(64, 9216)
	  fail "value not within limit (64-9216)"
	end
  end
 end 
 
 newproperty(:ip_addr) do
  desc 'ip address of interface'
 end 
 
 newproperty(:ip_prefix_len) do
  desc 'integer from 1-32'
  
  munge do |value|
        value.to_i
  end
  
  validate do |value|
	unless value.to_i.between?(1, 32)
	  fail "value not within limit (1-32)"
	end
  end
 end 
 

 newproperty(:admin_state) do
  desc 'one of up or down'
 end
 
end