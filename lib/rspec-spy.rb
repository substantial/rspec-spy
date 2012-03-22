require 'rspec-spy/version'

require 'rspec/matchers'
RSpec::Matchers.define :have_received do |sym, args, block|
  
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

      def it(description, &block)
        @example_group.context do
          let(:__spy__, &block)

          it description do
          end
        end
      end

      alias :specify :it
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
