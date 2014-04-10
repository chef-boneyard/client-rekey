# client-rekey-cookbook

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

## License and Authors

License:: Apache 2.0 (see: LICENSE)
Author:: Chef Software, inc.
