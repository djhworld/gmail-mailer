require "gmail-mailer.rb"
require 'fileutils'
require 'test/unit'
class TestMessage < Test::Unit::TestCase
  def create_file(filename, size)
    File.open(filename,'w') do |f|
      f.puts "-"*size
    end
  end

  def setup
    @files = ['file1','file2','file3']
    @dir = File.expand_path("./tmpdir")
    Dir.mkdir(@dir)
    createTmpFiles
    @msg = GmailMailer::Message.new("to","subject","body")
  end

  def teardown
    @files.each do |file|
      FileUtils.rm(file)
    end
    Dir.rmdir(@dir)
    @msg = nil
  end
  
  def createTmpFiles
    @files.each do |file|
      create_file(file, rand(1024))
    end
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

  def test_to_with_array_of_more_than_acceptable_recipients
    to = ("a@b.c,"*501).split(',')
    assert_raise(ArgumentError) {
      @msg.to= to
    }
  end
  

  def test_add_attachment
    @msg.add_attachment(@files.first)
    assert_equal(1,@msg.attachments.count, "There should be 1 item in the list!")
  end

  def test_add_attachments
    @msg.add_attachment(@files.pop)
    @msg.add_attachment(@files.pop)
    assert_equal(2,@msg.attachments.count, "There should be 2 items in the list!")
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
    assert_raise(ArgumentError) { @msg.add_attachment("asjdasjdhasdjhaksjdh") }
  end

  def test_add_file_that_is_actually_a_dir
    assert_raise(ArgumentError) { @msg.add_attachment(@dir) }
  end

  def test_get_attachment_size
    begin
      file = "file5"
      create_file(file, 1024*1024)
      size = File.size(file)
      @msg.add_attachment(file)
      assert_equal(size, @msg.get_attachments_size)
    ensure
      FileUtils.rm(file)
    end
  end

  def test_get_attachment_size_with_multiple_attachments
    begin
      file = "file5"
      file2 = "file6"
      create_file(file, 1024*1024)
      create_file(file2,(1024*1024)*5)
      size = File.size(file)
      size2 = File.size(file2)
      @msg.add_attachment(file)
      @msg.add_attachment(file2)
      assert_equal(size+size2, @msg.get_attachments_size)
    ensure
      FileUtils.rm(file)
      FileUtils.rm(file2)
    end
  end

  def test_add_attachment_with_over_limit
      begin

        file = "file5"
        file2 = "file6"
        create_file(file, 1024*1024)
        create_file(file2,(1024*1024)*25)
        size = File.size(file)
        size2 = File.size(file2)
        assert_raise(ArgumentError) {
          @msg.add_attachment(file)
          @msg.add_attachment(file2)
        }
      ensure
        FileUtils.rm(file)
        FileUtils.rm(file2)
      end
  end
end

