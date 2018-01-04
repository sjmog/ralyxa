lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ralyxa/version'

Gem::Specification.new do |spec|
  spec.name          = 'ralyxa'
  spec.version       = Ralyxa::VERSION
  spec.authors       = ['Sam Morgan']
  spec.email         = ['samm@makersacademy.com']

  spec.summary       = 'A Ruby framework for interacting with Amazon Alexa.'
  spec.description   = 'A Ruby framework for interacting with Amazon Alexa. Designed to work with Sinatra, although can be used with a few other web frameworks.'
  spec.homepage      = 'https://github.com/sjmog/ralyxa'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3.1'

  spec.add_dependency 'alexa_verifier', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'
  spec.add_development_dependency 'timecop', '~> 0.9'
  spec.add_development_dependency 'vcr',     '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
