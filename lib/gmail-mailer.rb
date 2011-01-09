require 'mail'
require 'gmail_xoauth'
module GmailMailer
  class Mailer
    def initialize(credentials)
      raise ArgumentError if !validate_credentials(credentials)
      @email_credentials = credentials
    end

    def send(message)
      mail = Mail.new do
        to message.to
        subject message.subject
        body message.body
        if(!message.attachments.empty?)
          add_file message.attachments.first 
        end
      end
      sendSMTP(mail)
    end

    # Use gmail_xoauth to send email
    def sendSMTP(mail)
      smtp = Net::SMTP.new(@email_credentials[:smtp_server], @email_credentials[:smtp_port])
      smtp.enable_starttls_auto
      secret = {
        :consumer_key => @email_credentials[:smtp_consumer_key],
        :consumer_secret => @email_credentials[:smtp_consumer_secret],
        :token => @email_credentials[:smtp_oauth_token],
        :token_secret => @email_credentials[:smtp_oauth_token_secret]
      }
      smtp.start(@email_credentials[:host], @email_credentials[:email], secret, :xoauth) do |session|
        print "Sending message..."
        session.send_message(mail.encoded, mail.from_addrs.first, mail.destinations)
        puts ".sent!"
      end
    end

    def validate_credentials(creds)
      false if creds.nil?
      false if !creds.key?:smtp_server or creds[:smtp_server].nil?
      false if !creds.key?:smtp_port or creds[:smtp_port].nil?
      false if !creds.key?:smtp_consumer_key or creds[:smtp_consumer_key].nil?
      false if !creds.key?:smtp_consumer_secret or creds[:smtp_consumer_secret].nil?
      false if !creds.key?:smtp_oauth_token or creds[:smtp_oauth_token].nil?
      false if !creds.key?:smtp_oauth_token_secret or creds[:smtp_oauth_token_secret].nil?
      false if !creds.key?:host or creds[:host].nil?
      false if !creds.key?:email or creds[:email].nil?
      return true
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
      @attachments << filepath 
    end

    def to=(to) 
      raise ArgumentError, "You must specify an email address to send the message to!" if(to.nil? or to.empty?)
      @to = to.join(";") if to.is_a?Array
      @to = to if to.is_a?String 
    end
  end
end
