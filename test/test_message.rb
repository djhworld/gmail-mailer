require "gmail-mailer.rb"
require 'test/unit'
class TestMessage < Test::Unit::TestCase
  def setup
    @msg = GmailMailer::Message.new("to","subject","body")
  end

  def teardown
    @msg = nil
  end

  def test_constructor
    @msg = GmailMailer::Message.new("djharperuk@gmail.com","Subject","Body")
    assert_not_nil(@msg, "Item did not appear to construct correctly")
  end

  def test_constructor_for_attributes
    to, subject, body = "a@b.c", "subject", "body"
    @msg = GmailMailer::Message.new(to, subject, body)
    assert_equal(to, @msg.to)
    assert_equal(subject, @msg.subject)
    assert_equal(body, @msg.body)
    assert_equal([], @msg.attachments)
  end

  def test_constructor_throws_exc_on_empty_to_field
    to, subject, body = "", "subject", "body"
    assert_raise(ArgumentError) { @msg = GmailMailer::Message.new(to, subject, body) }
  end

  def test_constructor_multiple_receivers
    first = "a@b.c"
    second = "b@c.d"
    to = [first,second]
    @msg = GmailMailer::Message.new(to, "", "")
    expected = to.join(";")
    assert_equal(expected, @msg.to, "Multiple receivers not detected")
  end

  def test_to_=
    to = "a@b.c"
    @msg.to= to
    assert_equal(to, @msg.to)
  end

  def test_to_with_array
    first = "a@b.c"
    second = "b@c.d"
    to = [first,second]
    @msg.to= to
    expected = to.join(";")
    assert_equal(expected, @msg.to, "Multiple receivers not detected")
  end
  

  def test_add_attachment
    @msg.add_attachment('test')
    assert_equal(1,@msg.attachments.count, "There should be 1 item in the list!")
  end

  def test_add_attachments
    @msg.add_attachment('test')
    @msg.add_attachment('test')
    @msg.add_attachment('test')
    @msg.add_attachment('test')
    assert_equal(4,@msg.attachments.count, "There should be 1 item in the list!")
  end

  def test_add_attachment_with_empty_string
    assert_raise(ArgumentError) { @msg.add_attachment("") }
    assert_equal(0, @msg.attachments.count, "There should be no items in the list!")
  end

  def test_add_attachment_with_nil_string
    assert_raise(ArgumentError) { @msg.add_attachment("") }
    assert_equal(0, @msg.attachments.count, "There should be no items in the list!")
  end

  def test_add_file_that_doesnt_exist
    assert_raise(IOError) { @msg.add_attachment("test") }
  end
end



