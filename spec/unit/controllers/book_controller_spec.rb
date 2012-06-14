require 'spec_helper'

describe BookController, :type => :controller do

  before(:each) do
    @book = build(:book)
    @book_aggregate = build(:book_aggregate)
    @aggregate_repo = stub("aggregate repository")
    @controller.aggregate_repository= @aggregate_repo
  end

  describe "GET 'index'" do
    it "should assign books" do
      books = [@book]
      Book.stub(:all).and_return(books)
      get :index
      assigns(:books).should == books
    end
  end

  describe "GET make" do
    it "should assign new book" do
      Book.stub(:new).and_return(@book)
      get :make
      assigns(:book).should equal(@book)
    end
  end

  describe "POST add" do
    it "should save new book with an id" do
      new_book_params = attributes_for(:book_aggregate).with_indifferent_access
      BookAggregateHelper.should_receive(:create).with(new_book_params).and_return(@book_aggregate)

      @aggregate_repo.should_receive(:save).with(@book_aggregate).and_return(true)
      post :add, book: new_book_params

      response.should redirect_to(action: :show, controller: :book, id: '123', notice: "Successfully added Book #{@book.title}")
    end
  end

  describe "GET show" do
    it "should show chosen book" do
      Book.should_receive(:first).with(:conditions => {:id => '123'}).and_return(@book)

      get :show, id: '123'

      assigns(:book).should equal @book
    end
  end

  describe "GET 'borrow'" do
    it "returns http success" do
      get 'borrow'
      response.should be_success
    end
  end

  describe "GET 'return'" do
    it "returns http success" do
      get 'return'
      response.should be_success
    end
  end

end
