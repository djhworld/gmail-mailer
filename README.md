Programatically send emails using a given gmail account. No username/passwords needed, just use your OAUTH credentials

## Information
This has only been tested on ruby 1.9.2

## Usage
### Creating a message
    message = GmailMailer::Message.new("to", "Hello Subject", "Hello Body")

### Adding attachments
    message.add_attachment("<path-to-file>")

### Setting up gmail-mailer
You will need to provide mailer with a hashmap containing the ouath details for your account.
    
    email_credentials = 
    {
        :smtp_oauth_token=>"<your outh_token>",
        :smtp_oauth_token_secret=>"<your ouath token secret>", 
        :email=>"<your gmail address>"
    }

### Sending a message
    mailer.send(message)

### Example application
    require 'gmail-mailer'
    email_credentials = 
    {
        :smtp_oauth_token=>"<your outh_token>",
        :smtp_oauth_token_secret=>"<your ouath token secret>", 
        :email=>"<your gmail address>"
    }

    # construct message
    message = GmailMailer::Message.new("to", "Hello Subject", "Hello Body")

    # add an attachment to the message
    message.add_attachment(File.expand_path('~/image.png'))

    # construct mailer using the email_credentials defined above
    mailer = GmailMailer::Mailer.new(email_credentials)

    # send email
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

