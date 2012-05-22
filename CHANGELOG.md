## Version 1.1.0

* `rspec-spy` no longer sets up the before hook for you, you need to do that manually. See the README

## Version 1.0.0

* Removed `strict_mode` and use `should_have_received` and `should_have_not_received` instead
of overriding the original RSpec::Mocks methods. `should_receive` and `should_not_receive` will
still work, but aren't recommended.
