require_relative '../models/aggregates/book_aggregate'
require_relative '../../lib/repositories/aggregate_repository'
require_relative '../../lib/broadcasters/event_broadcaster'
require_relative '../models/event_listeners/book_created_listener'
require_relative '../models/event_listeners/book_borrowed_listener'

class BookController < ApplicationController
  attr_writer :aggregate_repository

  def aggregate_repository
    @aggregate_repository ||= -> {
      broadcaster = EventStore::EventBroadcaster.new
      broadcaster.register_listener ::BookCreatedListener.new
      broadcaster.register_listener ::BookBorrowedListener.new
      EventStore::AggregateRepository.new(
          event_broadcaster: broadcaster
      )
    }.call
  end

  def index
    @books = Book.all
  end

  def show
    book = Book.first :conditions => {:id => params[:id]}
    @book = book
  end

  def make
    @book = Book.new
  end

  def add
    new_book = BookAggregateHelper.create(params[:book])

    respond_to do |format|
      if aggregate_repository.save new_book
        format.html {
          redirect_to(
              action: :show,
              controller: :book,
              id: new_book.id,
              notice: "Successfully added Book #{new_book.title}"
          )
        }
      end
    end
  end

  def borrow
    id = params[:id]
    book = aggregate_repository.find_aggregate_with_id id
    book.borrow
    aggregate_repository.save book
    redirect_to controller: :book, action: :show, id: id, notice: "Book #{book.title} borrowed"
  end

  def return
  end
end
