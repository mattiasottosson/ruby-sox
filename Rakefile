# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = "ruby-sox"
  gem.homepage    = "http://github.com/greyblake/ruby-sox"
  gem.license     = "MIT"
  gem.summary     = %Q{Wrapper around sox sound tool}
  gem.description = %Q{Wrapper around sox sound tool}
  gem.email       = ["rubygems@tmxcredit.com", "blake131313@gmail.com"]
  gem.authors     = ["TMX Credit", "Potapov Sergey"]

  gem.files = Dir["lib/**/*"] +
              Dir['README.markdown'] +
              Dir['LICENSE.txt']
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec
