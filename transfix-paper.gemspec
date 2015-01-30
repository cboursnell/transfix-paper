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

  gem.add_dependency 'fixwhich', '~> 1.0', '>= 1.0.2'

  gem.add_development_dependency 'rake', '~> 10.3', '>= 10.3.2'
  gem.add_development_dependency 'turn', '~> 0.9', '>= 0.9.7'
  gem.add_development_dependency 'minitest', '~> 4', '>= 4.7.5'
  gem.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
  gem.add_development_dependency 'shoulda-context', '~> 1.2', '>= 1.2.1'
  gem.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.2'
end
