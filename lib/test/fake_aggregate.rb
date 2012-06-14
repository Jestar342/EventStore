require_relative "../aggregate"

class FakeAggregate
  include EventStore::Aggregate
  attr_accessor :event_replayed

  def raise_event ()
    record_event FakeEvent.new(aggregate_id: id)
  end
end