require "bundler/gem_tasks"

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

task :console do
  begin
    # use Pry if it exists
    require 'pry'
    require 'net/openvpn'
    Pry.start
  rescue LoadError
    require 'irb'
    require 'irb/completion'
    require 'net/openvpn'
    ARGV.clear
    IRB.start
  end
end

task :c => :console
