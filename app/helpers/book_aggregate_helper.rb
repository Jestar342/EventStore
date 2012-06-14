require_relative '../models/aggregates/book_aggregate'

module BookAggregateHelper
  def self.create(params)
    book = ::BookAggregate.new
    book.create params
    book
  end
end