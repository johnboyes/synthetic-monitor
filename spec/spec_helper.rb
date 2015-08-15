require 'rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/dsl'


Capybara.configure do |c|
  c.javascript_driver = :poltergeist
  c.default_driver = :poltergeist
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 1000)
end

# Below is a workaround for sporadic timeout errors, taken from https://gist.github.com/afn/c04ccfe71d648763b306
# Also see https://github.com/ariya/phantomjs/issues/12234

CAPYBARA_TIMEOUT_RETRIES = 3

RSpec.configure do |config|
  config.around(:each, type: :feature) do |ex|
    example = RSpec.current_example
    CAPYBARA_TIMEOUT_RETRIES.times do |i|
      example.instance_variable_set('@exception', nil)
      self.instance_variable_set('@__memoized', nil) # clear let variables
      ex.run
      break unless example.exception.is_a?(Capybara::Poltergeist::TimeoutError)
      puts("\nCapybara::Poltergeist::TimeoutError at #{example.location}\n   Restarting phantomjs and retrying...")
      restart_phantomjs
    end
  end
end

def restart_phantomjs
  puts "-> Restarting phantomjs: iterating through capybara sessions..."
  session_pool = Capybara.send('session_pool')
  session_pool.each do |mode,session|
    msg = "  => #{mode} -- "
    driver = session.driver
    if driver.is_a?(Capybara::Poltergeist::Driver)
      msg += "restarting"
      driver.restart
    else
      msg += "not poltergeist: #{driver.class}"
    end
    puts msg
  end
end
