require 'rspec-spy/version'

require 'rspec/matchers'
require 'rspec/mocks'

RSpec::Mocks::Methods.class_eval do
  def should_receive_with_spy_check(message, opts={}, &block)
    __mock_proxy.add_message_expectation(opts[:expected_from] || caller(1)[0], message.to_sym, opts, &block)
  end

  def should_not_receive_with_spy_check(message, &block)
    __mock_proxy.add_negative_message_expectation(caller(1)[0], message.to_sym, &block)
  end

  alias_method :should_receive!, :should_receive
  alias_method :should_receive, :should_receive_with_spy_check

  alias_method :should_not_receive!, :should_not_receive
  alias_method :should_not_receive, :should_not_receive_with_spy_check
end

require 'rspec/core/spy_proxy'

module RSpec
  module Spy
    def self.included(mod)
      mod.extend ExampleGroupMethods
    end

    module ExampleGroupMethods
      def spy(&block)
        proxy = RSpec::Core::SpyProxy.new(self)
        proxy.instance_eval(&block)
      end
    end
  end
end

RSpec::Core::ExampleGroup.class_eval do
  include RSpec::Spy
end

RSpec.configure do |config|
  config.before(:each) do |example|
    example.spy_setup if example.respond_to? :spy_setup
  end
end

