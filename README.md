simple gem to allow you to send emails using your gmail account (without having to fiddle around with passwords)

## Usage
### Creating a message
    message = GmailMailer::Message.new("to", "from", "Hello Subject", "Hello Body")

### Adding attachments
*NOTE:* Only single attachments work at the current moment in time 
    message.add_attachment(Filepath)

### Setting up gmail-mailer
You will need to provide mailer with a hashmap containing the ouath details for your account.

### Sending a message
    mailer.send(message)

### Example application
    require 'gmail-mailer'
    email_credentials = 
    {
        :smtp_server=>"smtp.gmail.com", 
        :smtp_port=>587, 
        :smtp_consumer_key=>"anonymous", 
        :smtp_consumer_secret=>"anonymous", 
        :smtp_oauth_token=>"<your outh_token>",
        :smtp_oauth_token_secret=>"<your ouath token secret>", 
        :host=>"gmail.com", 
        :email=>"<your gmail address>"
    }

    message = GmailMailer::Message.new("to","from", "Hello Subject", "Hello Body")
    message.add_attachment(File.expand_path('~/image.png'))

    mailer = GmailMailer::Mailer.new(email_credentials)
    mailer.send(message)
       
### Contributing to gmail-mailer
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2011 Daniel Harper. See LICENSE.txt for
further details.
