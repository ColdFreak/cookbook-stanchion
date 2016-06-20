#
# Cookbook Name:: stanchion
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "install_stanchion_from_packagecloud" do
  code <<-EOH
  curl -s https://packagecloud.io/install/repositories/basho/stanchion/script.rpm.sh | bash
  yum install stanchion-#{node['stanchion']['major_number']}.#{node['stanchion']['minor_number']}.#{node['stanchion']['incremental']}-#{node['stanchion']['build']}.el7.centos.x86_64
  EOH
  not_if "which stanchion"
end

riak_ip = ""
if node['stanchion']['riak_ip'] then
  riak_ip  = node['stanchion']['riak_ip']
else
  riak_ip  = node['ipaddress']
end

template "/etc/stanchion/stanchion.conf" do
  source "default/stanchion.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :ip => riak_ip,
    :admin_key => node['riak-cs']['admin_key'],
    :admin_secret => node['riak-cs']['admin_secret']
  })
end
