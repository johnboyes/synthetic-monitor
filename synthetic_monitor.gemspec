Gem::Specification.new do |spec|
  spec.name        = 'synthetic_monitor'
  spec.version     = '0.0.0'
  spec.date        = '2015-04-28'
  spec.summary     = "Synthetic Monitor"
  spec.description = "A simple synthetic monitoring gem"
  spec.authors     = ["John Boyes"]
  spec.email       = 'john.boyes@bskyb.com'
  spec.files       = ["lib/synthetic_monitor.rb"]
  spec.homepage    = 'https://github.com/bskyb-commerce/synthetic-monitor'
  spec.license     = 'MIT'

  spec.add_dependency 'rspec', '3.2.0' #locked the version as we use an internal api workaround to programatically execute the rspec tests
end