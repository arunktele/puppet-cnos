ip_intf{'Ethernet1/1':
   ensure => 'present', 
#   ip_addr => "1.1.1.1",
#   bridge_port => "no",
#   if_name => "Ethernet1/1",
#   mtu => 1501,
#   vrf_name => "default",
   admin_state => "down",
   ip_prefix_len => 24
}
