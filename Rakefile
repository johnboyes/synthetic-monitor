require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << %w(test lib)
  task.pattern = 'functional_test/functional_test.rb'
end

task :default => :test