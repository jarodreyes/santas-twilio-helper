# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'santas_twilio_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "santas_twilio_helper"
  spec.version       = SantasTwilioHelper::VERSION
  spec.authors       = ["Jarod Reyes"]
  spec.email         = ["jreyes@twilio.com"]
  spec.summary       = 'all the tools santas little helper might need. Powered by Twilio.'
  spec.description   = 'All the tools Santas Helper might need. Send MMS, check Santas progress, register childs name, etc.'
  spec.homepage      = "https://github.com/jarodreyes/star-trek-twilio"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.18'
  spec.add_dependency 'paint'
  spec.add_dependency 'json'
  spec.add_dependency 'twilio-ruby', '~> 3.11'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
