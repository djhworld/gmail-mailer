require 'gmail-mailer.rb'
require 'yaml'
require 'test/unit'

class TestMailSender < Test::Unit::TestCase
  PRIVATE_CREDENTIALS = "files/private_key_conf_file"
  def setup
    root = File.expand_path(File.dirname(__FILE__))
    root = File.expand_path("../test", root)
    file = File.join(root, "/#{PRIVATE_CREDENTIALS}")
    raise Exception, "You have not setup a credentials file for your gmail account to test with" if !File.exists?(file)
    @config = YAML.load_file(file).inject({}){|memo,(k,v)| memo[k.to_sym] = v.to_s; memo}
  end

  def test_send_message
   assert_nothing_raised {
      mailer = GmailMailer::Mailer.new(@config)
      message = GmailMailer::Message.new(@config[:email], "Hello Subject", "Hello Body")
      mailer.send(message)
   }
  end
end


