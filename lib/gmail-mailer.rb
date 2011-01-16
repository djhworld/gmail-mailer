require 'mail'
require 'gmail_xoauth'
module GmailMailer
  SMTP_SERVER = "smtp.gmail.com"
  SMTP_PORT = "587"
  SMTP_HOST = "gmail.com"
  SMTP_CONSUMER_KEY = "anonymous"
  SMTP_CONSUMER_SECRET = "anonymous"
  ATTACHMENTS_SIZE_LIMIT = (1024*1024)*25 #25mb attachment limit
  RECIPIENT_LIMIT = 500
  MAX_RETRY = 2
  class Mailer
    def initialize(credentials)
      begin
        validate_credentials(credentials)
      rescue
        raise
      end
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

      retry_attempts = 0

      begin
        send_smtp(mail)
      rescue => message
        puts "Error occured attempting to send mail => #{message}"

        raise message if(retry_attempts > MAX_RETRY)
        puts "Retry: #{retry_attempts+1}/#{MAX_RETRY+1}"
        retry_attempts = retry_attempts.succ
        retry
      end
    end

    # Use gmail_xoauth to send email
    def send_smtp(mail)
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
      msg = "ERROR: Email credentials are invalid:"
      raise ArgumentError, "#{msg} The credentials you have posted are nil" if creds.nil?
      raise ArgumentError, "#{msg} You must provide a smtp_oauth_token value!" if !creds.key?:smtp_oauth_token or creds[:smtp_oauth_token].nil? or creds[:smtp_oauth_token].empty?
      raise ArgumentError, "#{msg} You must provide a smtp_oauth_token_secret value!" if !creds.key?:smtp_oauth_token_secret or creds[:smtp_oauth_token_secret].nil? or creds[:smtp_oauth_token_secret].empty?
      raise ArgumentError, "#{msg} You must provide an email value" if !creds.key?:email or creds[:email].nil? or creds[:email].empty?
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

      size = File.size(filepath)
      print "Adding attachment: #{filepath} " 
      printf("(%5.4f kb)",size.to_f/1024.0)
      puts
      raise ArgumentError, "There is a #{ATTACHMENTS_SIZE_LIMIT/1024/1024}mb limit on attachments}" if (get_attachments_size + size) > ATTACHMENTS_SIZE_LIMIT
      @attachments << filepath 
    end

    def to=(to) 
      raise ArgumentError, "You must specify an email address to send the message to!" if(to.nil? or to.empty?)
      raise ArgumentError, "You cannot send a message to more than #{RECIPIENT_LIMIT} recipients" if to.is_a?Array and to.count > RECIPIENT_LIMIT
      @to = to.join(";") if to.is_a?Array 
      @to = to if to.is_a?String 
    end

    def get_attachments_size
      attachments_size = 0
      @attachments.each do |attachment|
        attachments_size += File.size(attachment)
      end
      return attachments_size
    end
  end
end
