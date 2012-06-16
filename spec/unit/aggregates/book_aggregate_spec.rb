require "spec_helper"

describe BookAggregate do
  describe BookCreated do
    before(:all) do
      book = BookAggregateHelper.create title: 'some title', :author => 'john'
      @event = book.new_events.first
    end

    it "should record title" do
      @event.title.should == 'some title'
    end

    it "should record author" do
      @event.author.should == 'john'
    end
  end

  describe BookBorrowed do
    before :all do
      @book = BookAggregate.new(id: 123, title: 'title', author: 'author')
      @book.borrow
      @event = @book.new_events.first
    end

    it "should set book unavailable" do
      @book.available?.should == false
    end

    it "should record BookBorrowed event" do
      @event.class.should equal BookBorrowed
    end
  end
end
