require 'rspec/spy/version'
require 'rspec/spy'
require 'rspec/spy/mock_methods'
require 'rspec/spy/example_group_methods'

RSpec.configure do |config|
  config.before(:each) do |example|
    example.spy_setup if example.respond_to? :spy_setup
  end
end

