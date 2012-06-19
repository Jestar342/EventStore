require_relative '../models/aggregates/book_aggregate'
require_relative '../../lib/repositories/aggregate_repository'
require_relative '../../lib/broadcasters/event_broadcaster'
require_relative '../models/event_listeners/book_created_listener'
require_relative '../models/event_listeners/book_borrowed_listener'
require_relative '../models/event_listeners/book_returned_listener'

class BookController < ApplicationController
  attr_writer :aggregate_repository

  def aggregate_repository
    @aggregate_repository ||= -> {
      broadcaster = EventStore::EventBroadcaster.new
      broadcaster.register_listener BookCreatedListener.new
      broadcaster.register_listener BookBorrowedListener.new
      broadcaster.register_listener BookReturnedListener.new
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
    book = aggregate_repository.find_aggregate_with_id params[:id]
    book.borrow
    aggregate_repository.save book
    redirect_to_show book.id, "Book #{book.title} borrowed"
  end

  def return
    book = aggregate_repository.find_aggregate_with_id params[:id]
    book.return
    aggregate_repository.save book
    redirect_to_show book.id, "Book #{book.title} returned"
  end

  def redirect_to_show(id, notice)
    redirect_to controller: :book, action: :show, id: id, notice: notice
  end

  def events
    events = aggregate_repository.find_aggregate_with_id(params[:id]).loaded_events
    respond_to do |format|
      format.json {
        render json: (events.collect { |event|
          {class_name: event.class.name, occured_on: event.created, sequence: event.sequence_id}
        })
      }
    end
  end
end
