require "spec_helper"
require_relative "../../../app/models/aggregates/book_aggregate"
require_relative "../../../app/models/events/book_created"

describe BookCreated do
  describe "When replayed" do
    before :all do
      @book = BookAggregate.new
      event = BookCreated.new title: 'title', author: 'author'
      event.replay @book
    end

    it "should set title" do
      @book.title.should == 'title'
    end

    it "should set author" do
      @book.author.should == 'author'
    end
  end
end