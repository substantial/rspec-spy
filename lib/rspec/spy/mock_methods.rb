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
    raise "#{method} should not be used outside of a spy block. Please put it in a spy block or use #{method}!."
  end

  def nil_check(method)
    return if RSpec::Mocks::Proxy.allow_message_expectations_on_nil?
    return unless nil?
    raise "You set an expectation on nil, maybe you're using an @instance_var? If you want to do this, use allow_message_expectations_on_nil."
  end
end

