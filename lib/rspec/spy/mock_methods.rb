require 'rspec/mocks'

RSpec::Mocks::Methods.class_eval do
  def should_have_received(message, opts={}, &block)
    check(:should_have_received)
    __mock_proxy.add_message_expectation(opts[:expected_from] || caller(1)[0], message.to_sym, opts, &block)
  end

  def should_not_have_received(message, &block)
    check(:should_not_have_received)
    __mock_proxy.add_negative_message_expectation(caller(1)[0], message.to_sym, &block)
  end

  private

  def check(method)
    spy_check(method)
    nil_check(method)
  end

  def spy_check(method)
    return if RSpec::Spy.ok_to_spy?
    raise "#{method} was called before RSpec::Spy(example). Make sure that your example is properly tagged (generally with :spy => true) and you have a before hook in your RSpec.configure that calls RSpec::Spy(example)."
  end

  def nil_check(method)
    return if RSpec::Mocks::Proxy.allow_message_expectations_on_nil?
    return unless nil?
    raise "You set an expectation on nil, maybe you're using an @instance_var before it is set? If you want to do this, use allow_message_expectations_on_nil."
  end
end

