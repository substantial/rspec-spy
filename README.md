# RSpec::Spy

This gem allows you to write mock expectations in an AAA (Arrange-Act-Assert) fashion
with RSpec::Mocks. It does this by allowing you to declare examples within a spy block,
which is effectively executed before everything else. Here's a simple example:

``` ruby
describe "Example" do
  let(:collaborator) { stub.as_null_object }

  before do
    collaborator.message
  end

  spy do
    it "should receive a message" do
      collaborator.should_receive :message
    end

    it "should not receive other_message" do
      collaborator.should_not_receive :other_message
    end
  end
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-spy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-spy

## Usage

Add to your spec_helper.rb:

``` ruby
require 'rspec-spy'
```

If you want to be warned when using should_receive outside of spy blocks (recommended)
add this to your spec_helper.rb:

``` ruby
# Require should_receive and should_not_receive to be inside spy blocks
# Use should_receive! and should_not_receive! outside spy blocks
RSpec::Spy.strict_mode = true
```

Now just put your spy expectations within spy blocks in your specs. You should be able to
use all of the functionality from rspec-mocks that you're used to, including spying on
class methods.

## Warnings

* This is a hack, you'll want to make sure everyone on your team is aware of the behavior
and these warnings. You may not actually even want to use this.
* You should probably avoid instance vars, it gets confusing because you cannot set them
in before blocks and use them in spy blocks. Remember, spy blocks actually happen before
before blocks.
* If your tests depend on the method you are spying on returning something then you'll
need to use `and_return` in your spy block and if you have normal examples you'll also
need to stub it. Yes, this is annoying, but that's how rspec-mocks works.

## Alternatives

* [matahari](https://github.com/mortice/matahari)
* [bourne](https://github.com/thoughtbot/bourne)
* [rspec-spies](https://github.com/technicalpickles/rspec-spies)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
