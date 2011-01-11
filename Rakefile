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
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "gmail-mailer"
  gem.homepage = "http://github.com/djhworld/gmail-mailer"
  gem.license = "MIT"
  gem.summary = %Q{Send emails using a your gmail account (via OAUTH)}
  gem.description = %Q{Programatically send emails using a given gmail account. No username/passwords needed, just use your OAUTH credentials}
  gem.email = "djharperuk@gmail.com"
  gem.authors = ["Daniel Harper"]
  gem.required_ruby_version = ">= 1.9.2"
  gem.add_dependency "mail","~> 2.2.14"
  gem.add_dependency "gmail_xoauth", "~> 0.3.0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
