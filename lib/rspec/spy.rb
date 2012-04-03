module RSpec
  module Spy
    class << self
      attr_accessor :in_run_spy
      attr_accessor :strict_mode
      alias_method :in_run_spy?, :in_run_spy
      alias_method :strict_mode?, :strict_mode

      def ok_to_spy?
        return true unless strict_mode?
        in_run_spy?
      end
    end
  end
end

