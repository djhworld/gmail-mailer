require 'mail'
require 'gmail_xoauth'
module GmailMailer
  SMTP_SERVER = "smtp.gmail.com"
  SMTP_PORT = "587"
  SMTP_HOST = "gmail.com"
  SMTP_CONSUMER_KEY = "anonymous"
  SMTP_CONSUMER_SECRET = "anonymous"
  class Mailer
    def initialize(credentials)
      result = validate_credentials(credentials)
      raise ArgumentError, "ERROR: Email credentials are invalid: -\n\n - #{result}" if result.nil? == false     
      @email_credentials = credentials
    end

    def send(message)
      mail = Mail.new do
        to message.to
        subject message.subject
        body message.body
      end
      if(!message.attachments.empty?)
        message.attachments.each do |attachment|
          mail.add_file(attachment)
        end
      end
      sendSMTP(mail)
    end

    # Use gmail_xoauth to send email
    def sendSMTP(mail)
      smtp = Net::SMTP.new(SMTP_SERVER, SMTP_PORT)
      smtp.enable_starttls_auto
      secret = {
        :consumer_key => SMTP_CONSUMER_KEY, 
        :consumer_secret => SMTP_CONSUMER_SECRET,
        :token => @email_credentials[:smtp_oauth_token],
        :token_secret => @email_credentials[:smtp_oauth_token_secret]
      }
      smtp.start(SMTP_HOST, @email_credentials[:email], secret, :xoauth) do |session|
        print "Sending message..."
        session.send_message(mail.encoded, mail.from_addrs.first, mail.destinations)
        puts ".sent!"
      end
    end

    def validate_credentials(creds)
      return "The credentials you have posted are nil" if creds.nil?
      return "You must provide a smtp_oauth_token value!" if !creds.key?:smtp_oauth_token or creds[:smtp_oauth_token].nil? or creds[:smtp_oauth_token].empty?
      return "You must provide a smtp_oauth_token_secret value!" if !creds.key?:smtp_oauth_token_secret or creds[:smtp_oauth_token_secret].nil? or creds[:smtp_oauth_token_secret].empty?
      return "You must provide an email value" if !creds.key?:email or creds[:email].nil? or creds[:email].empty?
      return nil 
    end
  end

  class Message
    attr_accessor :subject, :body 
    attr_reader :to, :attachments
    def initialize(to, subject="", body="")
      self.to=(to)
      @subject = subject
      @body = body
      @attachments = []
    end

    def add_attachment(filepath)
      raise ArgumentError, "You must specify a file to send" if filepath.nil? or filepath.empty?
      raise ArgumentError, "File #{filepath} does not exist" if !File.exist?(filepath)  
      raise ArgumentError, "#{filepath} file is a directory, this is not supported" if File.directory?(filepath)
      @attachments << filepath 
    end

    def to=(to) 
      raise ArgumentError, "You must specify an email address to send the message to!" if(to.nil? or to.empty?)
      @to = to.join(";") if to.is_a?Array
      @to = to if to.is_a?String 
    end
  end
end
