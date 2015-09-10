# client-rekey Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/client-rekey.svg?branch=master)](http://travis-ci.org/chef-cookbooks/client-rekey)
[![Cookbook Version](https://img.shields.io/cookbook/v/client-rekey.svg)](https://supermarket.chef.io/cookbooks/client-rekey)

Regenerates a chef-client's API key. You want to use this if you believe
your client keys could be exposed as a result of the heartbleed
vulnerability.

By default, this cookbook will cause chef-client to rekey itself every
24 hours. This can be adjusted with the attribute
`node['client-rekey']['interval']`, which is the maximum allowed age of
the client key in seconds.

The library in this cookbook will honor the client configuration setting
`local_key_generation`. If set to true in the `client.rb` configuration
file, the private key will be generated locally and only the public key
will travel over the wire. This requires a Chef 11 server.

## Warning ##

If you use chef-vault or any other code that uses your client's keys,
you'll need to re-encrypt your data each time you rekey.

## Supported Platforms

This is expected to work on all platforms that chef-client supports.

## Attributes

`node['client-rekey']['interval']`: This recipe uses the mtime of your
client.pem to determine when it was last updated. If the difference
between now and the file's mtime is greater than this interval setting,
your client key will be regenerated.

## Usage

### client-rekey::default

Include `client-rekey` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[client-rekey::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License & Authors
```text
Copyright:: 2009-2015, Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
