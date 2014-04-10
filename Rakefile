require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :all_the_tests)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'kitchen'
require 'foodcritic'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

namespace :style do
  desc 'Run Rubocop ruby style checks'
  Rubocop::RakeTask.new(:ruby)

  desc 'Run FoodCritic style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style chekcs'
task style: ['style:chef', 'style:ruby']

desc 'Run ChefSpec tests'
RSpec::Core::RakeTask.new(:spec)

namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

task travis: [:style, :spec]

task default: [:style, :spec, 'integration:vagrant']

