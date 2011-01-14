require "gmail-mailer.rb"
require 'yaml'
require 'test/unit'
class TestMailer < Test::Unit::TestCase
  CREDS_FILE = "files/email_conf"
  def setup
    root = File.expand_path(File.dirname(__FILE__))
    root = File.expand_path("../test", root)
    file = File.join(root, "/#{CREDS_FILE}")
    @credentials = YAML.load_file(file).inject({}){|memo,(k,v)| memo[k.to_sym] = v.to_s; memo}
    @mailer = GmailMailer::Mailer.new(@credentials)
  end

  def teardown
    @credentials = nil
  end

  def test_constructor
    assert_nothing_raised { @mailer = GmailMailer::Mailer.new(@credentials) }
  end

  def test_constructor_with_nil_credentials
    assert_raise(ArgumentError) { @mailer = GmailMailer::Mailer.new(nil) }
  end

  def test_constructor_with_no_smtp_oauth_token
    assert_raise(ArgumentError) {
      @credentials.delete(:smtp_oauth_token)
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end
  
  def test_constructor_with_nil_smtp_outh_token
    assert_raise(ArgumentError) {
      @credentials[:smtp_oauth_token] = nil
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end

  def test_constructor_with_empty_smtp_oauth_token
    assert_raise(ArgumentError) {
      @credentials[:smtp_oauth_token] = "" 
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end
  
  def test_constructor_with_no_smtp_oauth_token_secret
    assert_raise(ArgumentError) {
      @credentials.delete(:smtp_oauth_token_secret)
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end
  
  def test_constructor_with_nil_smtp_outh_token_secret
    assert_raise(ArgumentError) {
      @credentials[:smtp_oauth_token_secret] = nil
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end

  def test_constructor_with_empty_smtp_oauth_token_secret
    assert_raise(ArgumentError) {
      @credentials[:smtp_oauth_token_secret] = "" 
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end

  def test_constructor_with_no_email
    assert_raise(ArgumentError) {
      @credentials.delete(:email)
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end
  
  def test_constructor_with_nil_email
    assert_raise(ArgumentError) {
      @credentials[:email] = nil
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end

  def test_constructor_with_empty_email
    assert_raise(ArgumentError) {
      @credentials[:email] = "" 
      @mailer = GmailMailer::Mailer.new(@credentials) 
    }
  end
end
