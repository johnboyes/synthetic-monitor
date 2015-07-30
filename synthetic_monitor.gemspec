Gem::Specification.new do |spec|
  spec.name        = 'synthetic_monitor'
  spec.version     = '0.1.0'
  spec.date        = '2015-04-28'
  spec.summary     = "Simple synthetic monitoring - runs rspec specs every x minutes and alerts on Slack if any tests fail."
  spec.description = "Simple synthetic monitoring - runs rspec specs given to it every x minutes (defaults to 5 minutes but can be overridden) and alerts on a Slack channel or group of your choosing if any tests fail."
  spec.author      = "John Boyes"
  spec.email       = 'john@edinburghwebservices.co.uk'
  spec.files       = ["lib/synthetic_monitor.rb"]
  spec.homepage    = 'https://github.com/johnboyes/synthetic-monitor'
  spec.license     = 'MIT'

  spec.add_dependency 'rspec', '3.2.0' #locked the version as we use an internal api workaround to programatically execute the rspec tests
  spec.add_dependency 'rest-client'
end