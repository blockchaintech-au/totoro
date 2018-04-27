
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "totoro/version"

Gem::Specification.new do |spec|
  spec.name          = "totoro"
  spec.version       = Totoro::VERSION
  spec.authors       = ["ShuHui18"]
  spec.email         = ["shu.hui@blockchaintech.net.au"]

  spec.summary       = %q{tool for rabbitmq}
  spec.description   = %q{Enpower rabbitmq to make it configrable}
  spec.homepage      = "https://github.com/blockchaintech-au/totoro"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = ["totoro"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
