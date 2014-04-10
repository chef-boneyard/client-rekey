#
# Cookbook Name:: client-rekey
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#


ruby_block "rekey-this-client" do
  block do
    node_name = Chef::Config[:node_name]
    client_key = Chef::Config[:client_key]
    Chef::ApiClient::Rekey.new(node_name, client_key).run
  end
end
