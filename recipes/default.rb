#
# Cookbook Name:: client-rekey
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#


ruby_block "rekey-this-client" do
  node_name = Chef::Config[:node_name]
  client_key = Chef::Config[:client_key]


  block do
    Chef::ApiClient::Rekey.new(node_name, client_key).run
    Chef::Log.info "Client key updated"
  end

  last_rekey = File.mtime(client_key)
  now = Time.now

  difference = now - last_rekey
  Chef::Log.info "Time since rekey: #{difference}"

  only_if { difference > node["client-rekey"]["interval"] }
end
