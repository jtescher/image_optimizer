# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_optimizer/version'

Gem::Specification.new do |gem|
  gem.name          = "image_optimizer"
  gem.version       = ImageOptimizer::VERSION
  gem.authors       = ["Julian Tescher"]
  gem.email         = ["jatescher@gmail.com"]
  gem.description   = %q{A simple image optimizer}
  gem.summary       = %q{Simply optimize images via jpegoptim or OptiPNG}
  gem.homepage      = "https://github.com/jtescher/image_optimizer"
  gem.license       = 'MIT'
  gem.signing_key   = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/
  gem.cert_chain    = ['gem-public_cert.pem']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec",     "~> 2.14.1"
  gem.add_development_dependency "rake",      "~> 10.1.0"
  gem.add_development_dependency "simplecov", "~> 0.7.1"
  gem.add_development_dependency "coveralls", "~> 0.6.7"
end
