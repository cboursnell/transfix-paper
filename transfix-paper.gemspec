# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transfix-paper/version'

Gem::Specification.new do |gem|
  gem.name          = "transfix-paper"
  gem.version       = TransfixPaper::VERSION::STRING.dup
  gem.authors       = ["Chris Boursnell"]
  gem.email         = ["cmb211@cam.ac.uk"]
  gem.summary       = %q{Transfix paper}
  gem.description   = %q{Transfix paper}
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.6"
  gem.add_development_dependency "rake"
end
