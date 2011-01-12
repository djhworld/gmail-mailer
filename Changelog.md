# gmail-mailer Changelog

### 0.4.0
* Added further validation on the `to` field
* Added ability to pass an array into the `to` field which will convert the `to` to a semi-colon delimited string
* Added getther and setter to `to` field for validation purposes
* ****Added support for multiple attachments - message class supports it, need to integrate into main emailer somehow**********
* ****Added support for multiple receivers - message class supports it, need to make sure this works email wise**********

### 0.3.0
* Removed the `from` field from `GmailMailer::Message`
* Added accessors for `to`, `subject`, `body` fields
* put validation on `to` field. 

### 0.2.0
* Removed attachments from the constructor and added `add_attachment` method

### 0.1.0
* Initial version
