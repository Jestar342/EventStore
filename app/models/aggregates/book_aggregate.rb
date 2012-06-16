require_relative '../../../lib/aggregate'
require_relative '../events/book_created'
require_relative '../events/book_borrowed'

class BookAggregate
  include EventStore::Aggregate
  include AttributeInitialize
  attr_accessor :title, :author, :available

  def create (params)
    raise "Cannot create an aggregate that is already created" unless id.nil?
    self.id = SecureRandom.uuid
    record_event BookCreated.new params
  end

  def borrow
    raise "Cannot borrow an already borrowed book" unless available?
    record_event BookBorrowed.new aggregate_id: id
  end

  def available?
    (@available = true) if @available.nil?
    @available
  end
end