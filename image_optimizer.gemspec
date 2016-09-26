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
  gem.summary       = %q{Simply optimize images via jpegoptim or OptiPNG or Gifsicle}
  gem.homepage      = "https://github.com/jtescher/image_optimizer"
  gem.license       = 'MIT'
  gem.signing_key   = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/
  gem.cert_chain    = ['certs/jtescher.pem']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "coveralls"
  gem.add_development_dependency "mime-types", "~> 1.25.1"
end
