# By putting this in lib/rspec/core it gets removed from the example file/line
# search so it can find a matching line from the backtrace
module RSpec
  module Core
    class SpyProxy
      def initialize(example_group)
        @example_group = example_group
      end

      def example_method(method, description, *args, &block)
        @example_group.context do
          let(:spy_setup, &block)

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
  end
end

