require 'rspec-spy/version'

require 'rspec/matchers'
require 'rspec/mocks'

RSpec::Mocks::Methods.class_eval do
  def should_receive_with_spy_check(message, opts={}, &block)
    spy_check(:should_receive)
    __mock_proxy.add_message_expectation(opts[:expected_from] || caller(1)[0], message.to_sym, opts, &block)
  end

  def should_not_receive_with_spy_check(message, &block)
    spy_check(:should_not_receive)
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
end

require 'rspec/core/spy_proxy'

module RSpec
  module Spy
    class << self
      attr_accessor :in_spy_setup
      attr_accessor :strict_mode
      alias_method :in_spy_setup?, :in_spy_setup
      alias_method :strict_mode?, :strict_mode

      def ok_to_spy?
        return true unless strict_mode?
        in_spy_setup?
      end
    end

    module ExampleGroupMethods
      def spy(&block)
        proxy = RSpec::Core::SpyProxy.new(self)
        proxy.instance_eval(&block)
      end
    end
  end
end

RSpec::Core::ExampleGroup.extend RSpec::Spy::ExampleGroupMethods

RSpec.configure do |config|
  config.before(:each) do |example|
    example.spy_setup if example.respond_to? :spy_setup
  end
end

