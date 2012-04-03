require 'rspec/core/spy_proxy'

module RSpec
  module Spy
    module ExampleGroupMethods
      def spy(&block)
        proxy = RSpec::Core::SpyProxy.new(self)

        if block
          proxy.instance_eval(&block)
        else
          proxy
        end
      end
    end
  end
end

RSpec::Core::ExampleGroup.extend RSpec::Spy::ExampleGroupMethods

