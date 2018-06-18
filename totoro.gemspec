
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'totoro/version'

Gem::Specification.new do |spec|
  spec.name          = 'totoro'
  spec.version       = Totoro::VERSION
  spec.authors       = ['ShuHui18']
  spec.email         = ['shu.hui@blockchaintech.net.au']

  spec.summary       = 'tool for rabbitmq'
  spec.description   = 'Enpower rabbitmq to make it configrable'
  spec.homepage      = 'https://github.com/blockchaintech-au/totoro'
  spec.license       = 'MIT'

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = ['totoro']
  spec.require_paths = ['lib']

  spec.add_dependency 'bunny', '~> 2.10'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
