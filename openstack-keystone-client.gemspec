# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keystone/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["yuanying", "atoato88"]
  gem.email         = ["yuanying@fraction.jp", "atoato88@gmail.com"]
  gem.description   = %q{OpenStack Keystone client for Ruby.}
  gem.summary       = %q{This is a client for the OpenStack Keystone API. There's a Ruby API.}
  gem.homepage      = "https://github.com/yuanying/ruby-openstack-keystone-client"

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
