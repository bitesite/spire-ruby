
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spire/version"

Gem::Specification.new do |spec|
  spec.name          = "spire"
  spec.version       = Spire::VERSION
  spec.authors       = ["Ryan O'Connor", "Casey Li", "Jack Wu", "Chris Francis", "Denis Dujota"]
  spec.email         = ["ryan.oconnor@bitesite.ca"]

  spec.summary       = "Spire is a wrapper over the Spire Systems API"
  spec.description   = "Spire is a wrapper over the Spire Systems API. It provides high level helper methods for consuming the API."
  spec.homepage      = "https://github.com/bitesite/spire-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "https://rubygems.org"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_dependency 'activemodel', '>= 3.2.0'
  spec.add_dependency 'json'
  spec.add_dependency 'rest-client', '>= 1.8.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "factory_bot", "~> 4.8"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
end
