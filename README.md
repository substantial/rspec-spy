# RSpec::Spy

This gem allows you to write mock expectations in an AAA (Arrange-Act-Assert) fashion
with RSpec::Mocks. It does this by allowing you to declare examples with `:spy => true`
or `:spy` (if you use `config.treat_symbols_as_metadata_keys_with_true_values = true`)
so that they are effectively executed before everything else. Here's a simple example:

``` ruby
describe "Example" do
  let(:collaborator) { stub.as_null_object }

  before do
    collaborator.message
  end

  it "should receive a message", :spy => true do
    collaborator.should_have_received :message
  end

  it "should not receive other_message", :spy => true do
    collaborator.should_not_have_received :other_message
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

Add to your spec_helper.rb in `RSpec.configure` **AFTER any other global before hooks, especially DatabaseCleaner**:

``` ruby
# any config.before hooks should go above

config.before(:each, :spy => true) do |example|
  RSpec::Spy(example)
end
```

## Usage

Just tag your examples with `:spy => true` or `:spy` (if you use
`config.treat_symbols_as_metadata_keys_with_true_values = true`)
You should be able to use all of the functionality from rspec-mocks that you're
used to, including spying on class methods.

``` ruby
it "should receive message", :spy => true do
  collaborator.should_have_received :message
end

# with config.treat_symbols_as_metadata_keys_with_true_values = true
it "should receive message", :spy do
  collaborator.should_have_received :message
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
  it "should receive a message", :spy => true do
    @collaborator.should_have_received :message
  end

  it "should not receive other_message", :spy => true do
    @collaborator.should_not_have_received :other_message
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

  it "should receive a message", :spy => true do
    collaborator.should_have_received(:message).and_return(5)
  end
end
```

## Alternatives

* [matahari](https://github.com/mortice/matahari)
* [bourne](https://github.com/thoughtbot/bourne)
* [rspec-spies](https://github.com/technicalpickles/rspec-spies)
* [gimme](https://github.com/searls/gimme)
* [fakes-rspec](https://github.com/developwithpassion/fakes-rspec)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
