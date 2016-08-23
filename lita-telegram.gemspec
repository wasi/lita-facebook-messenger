Gem::Specification.new do |spec|
  spec.name          = "lita-facebook-messenger"
  spec.version       = "0.1.0"
  spec.authors       = ["Philipp Wesner"]
  spec.email         = ["pwesner@innomind.de"]
  spec.description   = "Facebook Messenger handler for the Lita ChatOps framework"
  spec.summary       = "Allows Lita to connect to and handle messages from the Facebook Messenger bot framework/API"
  spec.homepage      = "https://github.com/wasi/lita-facebook-messenger"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"

  spec.add_runtime_dependency 'facebook-messenger'
end
