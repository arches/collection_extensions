# -*- encoding: utf-8 -*-
require File.expand_path('../lib/collection_extensions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Doyle"]
  gem.email         = ["archslide@gmail.com"]
  gem.description   = %q{Lightweight framework for adding methods to groups of ActiveRecord objects}
  gem.summary       = %q{Light-weight framework for adding methods to groups of ActiveRecord objects}
  gem.homepage      = "http://github.com/arches/collection_extensions"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "collection_extensions"
  gem.require_paths = ["lib"]
  gem.version       = CollectionExtensions::VERSION
end
