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
end
