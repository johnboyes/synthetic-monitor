require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << "functional_test"
  task.pattern = 'functional_test/**/*_test.rb'
end

task :default => :test
