require 'rspec/mocks'

RSpec::Mocks::Methods.class_eval do
  def should_receive_with_spy_check(message, opts={}, &block)
    spy_check(:should_receive)
    nil_check(:should_receive)
    __mock_proxy.add_message_expectation(opts[:expected_from] || caller(1)[0], message.to_sym, opts, &block)
  end

  def should_not_receive_with_spy_check(message, &block)
    spy_check(:should_not_receive)
    nil_check(:should_not_receive)
    __mock_proxy.add_negative_message_expectation(caller(1)[0], message.to_sym, &block)
  end

  alias_method :should_receive!, :should_receive
  alias_method :should_receive, :should_receive_with_spy_check

  alias_method :should_not_receive!, :should_not_receive
  alias_method :should_not_receive, :should_not_receive_with_spy_check

  private

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

