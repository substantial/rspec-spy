# RSpec::Spy

This gem allows you to write mock expectations in an AAA (Arrange-Act-Assert) fashion
with RSpec::Mocks. It does this by allowing you to declare examples within a `spy` block,
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

Add to your spec_helper.rb:

``` ruby
require 'rspec-spy'
```

If you want to be warned when using `should_receive` outside of `spy` blocks (recommended)
add this to your `spec_helper.rb`:

``` ruby
# Require should_receive and should_not_receive to be inside spy blocks
# Use should_receive! and should_not_receive! outside spy blocks
RSpec::Spy.strict_mode = true
```

## Usage

Just put your spy expectations within `spy` blocks in your specs instead of in `before` blocks.
You should be able to use all of the functionality from rspec-mocks that you're
used to, including spying on class methods.

``` ruby
spy do
  it "should receive message" do
    collaborator.should_receive :message
  end
end

# Shorthand:
spy.it "should receive message" do
  collaborator.should_receive :message
end
```

## Warnings

* This is a hack, you'll want to make sure everyone on your team is aware of the behavior
and these warnings.
* You should probably avoid instance vars and stick to `let`, it gets confusing because you cannot set them
in `before` blocks and use them in `spy` blocks. Remember, `spy` blocks actually happen before
`before` blocks. Example (see the example at the beginning of the readme for the right way):

``` ruby
describe "what not to do" do
  before do
    @collaborator = stub.as_null_object
    @collaborator.message
  end

  # These will fail because @collaborator is nil because this happens
  # before the above before block
  spy do
    it "should receive a message" do
      @collaborator.should_receive :message
    end

    it "should not receive other_message" do
      @collaborator.should_not_receive :other_message
    end
  end
end
```
* If your tests depend on the method you are spying on returning something then you'll
need to use `and_return` in your `spy` block and if you have normal examples you'll also
need to `stub` it. Yes, this is annoying, but that's how rspec-mocks works and it's one 
of the many reasons you shoudln't mock when the return value matters (just `stub`). Example:

``` ruby
describe "stubbing and mocking at the same time" do
  let(:collaborator) { stub.as_null_object }
  before do
    collaborator.stub(:message) { 5 }
    @result = collaborator.message

    # This will fail unless you use and_return
    @result.should == 5
  end

  it "should return 5" do
    # This will fail unless you stub in before
    @result.should == 5
  end

  spy do
    it "should receive a message" do
      collaborator.should_receive(:message).and_return(5)
    end
  end
end
```

## Alternatives

* [matahari](https://github.com/mortice/matahari)
* [bourne](https://github.com/thoughtbot/bourne)
* [rspec-spies](https://github.com/technicalpickles/rspec-spies)
* [gimme](https://github.com/searls/gimme)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
