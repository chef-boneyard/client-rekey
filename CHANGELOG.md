client-rekey Cookbook CHANGELOG
===============================
This file is used to list changes made in each version of the client-rekey cookbook.

## 0.3.0 (2017-04-20)

- Resolve Cookstyle warnings
- Changed to Chef::ServerAPI from Chef::REST as Chef::REST is deprecated when on Chef > 12.7
- Switch testing to delivery local from Rake
- Use a standardized license string in the metadata
- Add chef_version metadata
- Add supports metadata

# 0.2.0
* Make API call Chef 10 compat
* Added travis and cookbook version badges to the readme
* Updated chefignore and .gitignore files
* Updated platforms in the Test Kitchen config
* Added standard Rubocop file
* Added Travis CI testing
* Removed yum from Berksfile and removed version constraint on Apt
* Added contributing and testing docs
* Updated Gemfile with testing deps
* Added maintainers.md and maintainers.toml
* Added rakefile for simplified testing
* Added source_url and issues_url metadata
* Added basic Chefspec convergence test
* Updated Berksfile with testing deps
* Updated Opscode -> Chef Software
* Resolved multiple rubocop warnings

# 0.1.0
Initial release of client-rekey

* Enhancements
  * an enhancement

* Bug Fixes
  * a bug fix
