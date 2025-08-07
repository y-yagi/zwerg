# Zwerg

Zwerg is a Ruby gem that watches for file changes and executes configurable actions based on YAML configuration files. It uses the [watchcat](https://github.com/y-yagi/watchcat) gem for efficient file system monitoring.

## Features

- Monitor files and directories for changes
- Support for recursive directory watching
- File pattern matching (glob patterns)
- Configurable actions triggered by file changes
- Variable substitution in action commands
- Command execution triggered by file changes, file operations, logging, file operations, logging
- Cross-platform support (Linux, macOS, Windows)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zwerg'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install zwerg
```

## Usage

1. Create a configuration file (default: `zwerg.yml`):

```yaml
watches:
  - path: "./src"
    recursive: true
    patterns:
      - "*.rb"
      - "*.yml"
    actions:
      - command: "echo 'Ruby file changed: {{file_name}}'"
      - command: "rubocop {{file_path}}"
```

2. Run Zwerg:

```bash
zwerg                    # Uses zwerg.yml
zwerg my_config.yml     # Uses custom config file
```

## Configuration

### Watch Configuration

Each watch entry can have the following properties:

- `path`: The file or directory to watch (required)
- `recursive`: Whether to watch subdirectories (default: true)
- `patterns`: Array of glob patterns to match files (optional, matches all if empty)
- `actions`: Array of actions to execute when files change (required)

### Action Configuration

Each action is simply a shell command:
```yaml
- command: "echo 'File changed: {{file_path}}'"
```

You can use any shell command, including complex operations with pipes, redirection, and conditional logic:
```yaml
- command: "if [ -f {{file_path}} ]; then echo 'File exists: {{file_name}}' >> changes.log; fi"
```

### Variable Substitution

The following variables can be used in action configurations:

- `{{file_path}}`: Full path to the changed file
- `{{file_dir}}`: Directory containing the file
- `{{file_name}}`: Name of the file (including extension)
- `{{file_base}}`: Name of the file without extension
- `{{file_ext}}`: File extension (including the dot)
- `{{event_type}}`: Type of event (create, modify, remove, access)

## Example Configuration

See `example_zwerg.yml` for a comprehensive example configuration file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/y-yagi/zwerg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/y-yagi/zwerg/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Zwerg project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/y-yagi/zwerg/blob/main/CODE_OF_CONDUCT.md).
