$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynamics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dynamics_client"
  s.version     = dynamicsClient::VERSION
  s.authors       = ["SBL"]
  s.email         = ["ops@superbeinglabs.org"]
  s.summary       = %q{Ruby dynamics API Client}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

end
