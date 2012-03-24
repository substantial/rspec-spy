require 'rspec-spy/version'

require 'rspec/matchers'
require 'rspec/mocks'

RSpec::Mocks::Methods.class_eval do
  def should_receive_with_spy_check(*args, &block)
    should_receive!(*args, &block)
  end

  alias_method :should_receive!, :should_receive
  alias_method :should_receive, :should_receive_with_spy_check

  def should_not_receive_with_spy_check(*args, &block)
    should_not_receive!(*args, &block)
  end

  alias_method :should_not_receive!, :should_not_receive
  alias_method :should_not_receive, :should_receive_with_spy_check
end

require 'rspec/core/hooks'
module RSpec
  module Spy
    def self.included(mod)
      mod.extend ExampleGroupMethods
    end

    class SpyProxy
      def initialize(example_group)
        @example_group = example_group
      end

      def example_method(method, description, *args, &block)
        @example_group.context do
          let(:__spy__, &block)

          send(method, description, *args) do
          end
        end
      end

      [
        :example,
        :it,
        :specify,
        :focused,
        :focus,
        :pending,
        :xexample,
        :xit,
        :xspecify
      ].each do |name|
        module_eval(<<-END_RUBY, __FILE__, __LINE__)
          def #{name}(desc=nil, *args, &block)
            example_method(:#{name}, desc, *args, &block)
          end
        END_RUBY
      end
    end

    module ExampleGroupMethods
      def spy(&block)
        setup_spy_hook

        proxy = SpyProxy.new(self)
        proxy.instance_eval(&block)
      end

      private
      def setup_spy_hook
        return if @spy_hook_setup

        let(:__spy__) {}
        hook = RSpec::Core::Hooks::BeforeHook.new({}) do
          __spy__
        end

        hooks[:before][:each].unshift hook
        @spy_hook_setup = true
      end
    end
  end
end

RSpec::Core::ExampleGroup.class_eval do
  include RSpec::Spy
end
