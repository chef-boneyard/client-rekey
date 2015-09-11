#
# Cookbook Name:: client-rekey
# Recipe:: default
# Author:: Daniel Deleo (<adan@chef.io>)
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

ruby_block 'rekey-this-client' do
  node_name = Chef::Config[:node_name]
  client_key = Chef::Config[:client_key]

  block do
    Chef::ApiClient::Rekey.new(node_name, client_key).run
    Chef::Log.info 'Client key updated'
  end

  last_rekey = File.mtime(client_key)
  now = Time.now

  difference = now - last_rekey
  Chef::Log.info "Time since rekey: #{difference}"

  only_if { difference > node['client-rekey']['interval'] }
end
