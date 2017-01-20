# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/invoice/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-invoice"
  spec.version       = Jekyll::Invoice::VERSION
  spec.authors       = ['Mark H. Wilkinson']
  spec.email         = ['mhw@dangerous-techniques.com']
  spec.summary       = %q{Produce invoices with Jekyll}
  spec.description   = %q{A collection of Jekyll plugins and conventions to produce nice HTML invoices.}
  spec.homepage      = 'http://github.com/mhw/jekyll-invoice'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'jekyll', '~> 3.3.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
