require 'rspec/core/spy_proxy'

module RSpec
  module Spy
    module ExampleGroupMethods
      def spy(&block)
        proxy = RSpec::Core::SpyProxy.new(self)
        proxy.instance_eval(&block)
      end
    end
  end
end

RSpec::Core::ExampleGroup.extend RSpec::Spy::ExampleGroupMethods

