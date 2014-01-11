# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dm-aspects/version'

Gem::Specification.new do |gem|
  gem.name          = "dm-aspects"
  gem.version       = DataMapper::Aspects::VERSION
  gem.authors       = ['StyleSeek Engineering Team']
  gem.email         = ['engineering@styleseek.com']
  gem.summary       = %q{Aspect-Oriented modules to add enhance your DataMapper models.}
  gem.description   = %q{Aspect-Oriented modules to add commonly needed methods and properties to your DataMapper models.}
  gem.homepage      = "https://github.com/styleseek/dm-aspects"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'dm-core'
  gem.add_dependency 'oj'
  
  gem.add_development_dependency "bundler", "~> 1.5"
  gem.add_development_dependency "rake"
end
