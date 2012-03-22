# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec-spy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Aaron Jensen"]
  gem.email         = ["aaronjensen@gmail.com"]
  gem.description   = %q{Enables AAA testing for rspec-mock}
  gem.summary       = "rspec-spy-#{RSpec::Spy::VERSION}"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspec-spy"
  gem.require_paths = ["lib"]
  gem.version       = RSpec::Spy::VERSION

  gem.add_dependency 'rspec', '~> 2.0'
  gem.add_dependency 'rspec-mocks', '~> 2.0'
end
