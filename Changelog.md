# gmail-mailer Changelog

### 0.4.5
* Removed restriction for 1.9.2

### 0.4.3
* Added attachment limits and recipient limits for messages
* Added retry functionality on sending mail
* Rejigged validation a little

### 0.4.2
* Made error messages for credentials more detailed

### 0.4.0
* Added further validation on the `to` field
* Added ability to pass an array into the `to` field which will convert the `to` to a semi-colon delimited string
* Added getther and setter to `to` field for validation purposes
* Added support for multiple attachments 
* Added support for multiple receivers 
* Added further validation for email credentials/reduced number of credentials needed by making some values default
* Added some primitive unit tests for sending email

### 0.3.0
* Removed the `from` field from `GmailMailer::Message`
* Added accessors for `to`, `subject`, `body` fields
* put validation on `to` field. 

### 0.2.0
* Removed attachments from the constructor and added `add_attachment` method

### 0.1.0
* Initial version
