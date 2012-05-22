module RSpec
  module Spy
    class << self
      attr_accessor :in_run_spy
      alias_method :in_run_spy?, :in_run_spy

      def ok_to_spy?
        in_run_spy?
      end
    end
  end

  def self.Spy(example)
    example.example.run_spy
  end
end

