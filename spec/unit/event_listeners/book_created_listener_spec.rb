require 'spec_helper'
require_relative '../../../app/models/event_listeners/book_created_listener'

describe BookCreatedListener do
  before(:all) do
    @listener = BookCreatedListener.new
  end

  describe "listen to relevant event" do
    it "should create book" do
      book = mock("mock book")
      Book.should_receive(:new).with(id: anything, title: 'title', author: 'author').and_return(book)
      book.should_receive(:save)

      @listener.listen_to BookCreated.new aggregate_id: '123', title: 'title', author: 'author'
    end
  end

  describe "listen to irrelevant event" do
    it "should not create book" do
      Book.should_not_receive(:new)

      event = stub("fake event")

      event.stub(:is_a?).with(BookCreated).and_return false

      @listener.listen_to event
    end
  end
end