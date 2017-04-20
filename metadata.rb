name 'client-rekey'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Regenerates your client key'
long_description 'Regenerates your client key-recommended for users affected by heartbleed'
version '0.2.0'

%w(aix amazon centos debian opensuse opensuseleap oracle redhat scientific suse ubuntu).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/client-rekey' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/client-rekey/issues' if respond_to?(:issues_url)
chef_version '>= 11' if respond_to?(:chef_version)
