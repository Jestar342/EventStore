require "spec_helper"

describe BookBorrowedListener do
  describe "Listening to BookBorrowed event" do

    before :each do
      @listener = BookBorrowedListener.new

      @book = mock("book")
    end

    it "should set Book to borrowed" do
      Book.should_receive(:find).with(id: 123).and_return @book
      @book.should_receive(:available=).with(false)
      @book.should_receive(:save)
      @listener.listen_to BookBorrowed.new(aggregate_id: 123)
    end
  end
end