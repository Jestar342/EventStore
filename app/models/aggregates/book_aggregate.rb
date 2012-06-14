require_relative '../../../lib/aggregate'
require_relative '../events/book_created'

class BookAggregate
  include EventStore::Aggregate
  include AttributeInitialize
  attr_accessor :title, :author

  def create (params)
    raise "Cannot create an aggregate that is already created" unless id.nil?
    self.id = SecureRandom.uuid
    record_event BookCreated.new params
  end
end