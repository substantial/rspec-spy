require 'rspec/spy/version'
require 'rspec/spy'
require 'rspec/spy/mock_methods'

RSpec::Core::Example.class_eval do
  def run_spy
    RSpec::Spy.in_run_spy = true
    @example_group_instance.instance_eval &@example_block
    RSpec::Spy.in_run_spy = false
    @example_block = proc {}
  end
end

RSpec.configure do |config|
  config.before(:each, :spy => true) do |example|
    example.example.run_spy
  end
end

