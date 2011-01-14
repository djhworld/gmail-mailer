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
PRIVATE_CREDENTIALS = "files/private_key_conf_file"
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true

  #tests sending a mail using user credentials (if provided)
  root = File.expand_path(File.dirname(__FILE__))
  root = File.expand_path("./test", root)
  file = File.join(root, "/#{PRIVATE_CREDENTIALS}")

  if File.exist?(file)
    puts
    puts "Will test sending a mail using your user credentials found in #{file}"
    puts
    test.test_files = ['test/mail_test_send.rb']
  else
    puts
    puts "WILL NOT BE TESTING MAIL SEND FUNCTIONALITY. IF YOU WISH TO TEST THIS, CREATE A FILE WITH THE FOLLOWING: - "
    puts
    puts "  smtp_oauth_token: <your outh token>"
    puts "  smtp_oauth_token_secret: <your oauth token secret>"
    puts "  email: <your email>"
    puts 
    puts "place this information in test/files/private_key_conf_file"
    puts
  end
end

task :default => :test
