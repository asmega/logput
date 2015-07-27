# -*- encoding: utf-8 -*-
require File.expand_path('../lib/logput/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Philip Lee"]
  gem.email         = ["asmega@ph-lee.com"]
  gem.description   = 'Rack middleware to output rails logs to a webpage'
  gem.summary       = 'Rack middleware to output rails logs to a webpage'
  gem.homepage      = "https://github.com/asmega/logput"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "logput"
  gem.require_paths = ["lib"]
  gem.version       = Logput::VERSION

  gem.add_dependency 'rack'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'fudge'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'cane'
  gem.add_development_dependency 'flay'
  gem.add_development_dependency 'flog'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'rake'
end
