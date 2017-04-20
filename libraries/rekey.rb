#
# Author:: Daniel DeLeo (<dan@opscode.com>)
# Copyright:: Copyright (c) 2012, 2014 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless 'd by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/server_api'

class Chef
  class ApiClient
    # ==Chef::ApiClient::Rekey
    #
    # This code is mostly a straight copy of the code that lives in
    # chef/api_client/registration on Chef 11.x. It would be cleaner to
    # subclass Chef::ApiClient::Rekey, but this class does not exist on Chef
    # 10.x and we want to support 10.x and 11.x.
    #
    # The one primary difference between this code and the code in chef core is
    # that this code is designed to use the client's own key to rekey itself.
    # Because it's intended to rekey only, support for client creation is
    # removed as well.
    #
    class Rekey
      attr_reader :destination
      attr_reader :name

      def initialize(name, destination)
        @name = name
        @destination = destination
        @server_generated_private_key = nil
      end

      # Runs the client registration process, including creating the client on
      # the chef-server and writing its private key to disk.
      def run
        assert_destination_writable!
        retries = Config[:client_registration_retries] || 5
        begin
          update
        rescue Net::HTTPFatalError => e
          # HTTPFatalError implies 5xx.
          raise if retries <= 0
          retries -= 1
          Chef::Log.warn("Failed to register new client, #{retries} tries remaining")
          Chef::Log.warn("Response: HTTP #{e.response.code} - #{e}")
          retry
        end
        write_key
      end

      def assert_destination_writable!
        if (File.exist?(destination) && !File.writable?(destination)) || !File.writable?(File.dirname(destination))
          raise Chef::Exceptions::CannotWritePrivateKey, "I cannot write your private key to #{destination} - check permissions?"
        end
      end

      def write_key
        ::File.open(destination, file_flags, 0600) do |f|
          f.print(private_key)
        end
      rescue IOError => e
        raise Chef::Exceptions::CannotWritePrivateKey, "Error writing private key to #{destination}: #{e}"
      end

      def update
        response = if http_api.respond_to?(:put)
                     http_api.put("clients/#{name}", put_data)
                   else
                     http_api.put_rest("clients/#{name}", put_data)
                   end
        @server_generated_private_key = if response.respond_to?(:private_key) # Chef 11
                                          response.private_key
                                        else # Chef 10
                                          response['private_key']
                                        end
        response
      end

      def put_data
        base_put_data = { name: name, admin: false }
        if self_generate_keys?
          base_put_data[:public_key] = generated_public_key
        else
          base_put_data[:private_key] = true
        end
        base_put_data
      end

      def http_api
        #  dep_version = Gem::Version.new('12.7.0')
        # running_version = Gem::Version.new(Chef::VERSION)
        # rc = Gem::Version.new(Chef::VERSION) < Gem::Version.new('12.7.0')
        # if running_version < dep_version
        #  @http_api ||= Chef::REST::RestRequest.new(Chef::Config[:chef_server_url])
        @http_api = if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12.7.0')
                      Chef::REST::RestRequest.new(Chef::Config[:chef_server_url])
                    else
                      @http_api ||= Chef::ServerAPI.new(
                        Chef::Config[:chef_server_url],
                        api_version: '0',
                        client_name: Chef::Config[:client_name],
                        signing_key_filename: Chef::Config[:client_key]
                      )
                    end
      end

      # Whether or not to generate keys locally and post the public key to the
      # server. Delegates to `Chef::Config.local_key_generation`. Servers
      # before 11.0 do not support this feature.
      def self_generate_keys?
        Chef::Config.local_key_generation
      end

      def private_key
        if self_generate_keys?
          generated_private_key.to_pem
        else
          @server_generated_private_key
        end
      end

      def generated_private_key
        @generated_key ||= OpenSSL::PKey::RSA.generate(2048)
      end

      def generated_public_key
        generated_private_key.public_key.to_pem
      end

      def file_flags
        base_flags = File::CREAT | File::TRUNC | File::RDWR
        # Windows doesn't have symlinks, so it doesn't have NOFOLLOW
        base_flags |= File::NOFOLLOW if defined?(File::NOFOLLOW)
        base_flags
      end
    end
  end
end
