# client-rekey-cookbook

Regenerates a chef-client's API key. You want to use this if you believe
your client keys could be exposed as a result of the heartbleed
vulnerability.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

None.

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
