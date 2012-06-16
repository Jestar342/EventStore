require "spec_helper"

describe BookReturnedListener do
  it "should return book" do
    listener = BookReturnedListener.new
    Book.should_receive(:where).with(id: 123).and_return Book
    book = mock("book")
    Book.should_receive(:first).and_return book
    book.should_receive(:available=).with true
    book.should_receive(:save)
    listener.listen_to BookReturned.new aggregate_id: 123
  end
end