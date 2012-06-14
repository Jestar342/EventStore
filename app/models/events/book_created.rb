require_relative "../../../lib/event"

class BookCreated
  include EventStore::Event
  attr_accessor :title, :author

  def initialize(params)
    self.id = SecureRandom.uuid
    self.title = params[:title]
    self.author = params[:author]
    self.aggregate_id = params[:aggregate_id]
  end

  def replay(aggregate)
    aggregate.title = self.title
    aggregate.author = self.author
  end
end