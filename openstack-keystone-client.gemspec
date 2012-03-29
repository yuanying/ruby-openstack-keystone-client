# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keystone/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["yuanying", "atoato88"]
  gem.email         = ["yuanying@fraction.jp", "atoato88@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.name          = "openstack-keystone-client"
  gem.require_paths = ["lib"]
  gem.version       = Keystone::Client::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "activesupport"
  gem.add_development_dependency "simplecov-rcov"
  gem.add_runtime_dependency "rest-client"
end
