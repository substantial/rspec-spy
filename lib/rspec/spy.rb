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
  end
end

