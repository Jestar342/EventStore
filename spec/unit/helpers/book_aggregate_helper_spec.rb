require "spec_helper"
require_relative "../../../app/helpers/book_aggregate_helper"

describe BookAggregateHelper do

  describe "Creating a BookAggregate" do
    before(:all) do
      @book = BookAggregateHelper.create title: 'title', author: 'author'
    end

    it "should create with supplied title" do
      @book.title.should == 'title'
    end

    it "should create with supplied author" do
      @book.author.should == 'author'
    end
  end
end