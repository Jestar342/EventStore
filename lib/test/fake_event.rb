require File.expand_path('../../event', __FILE__)

class FakeEvent
  include AttributeInitialize
  include EventStore::Event

  def initialize(attrs={})
    self.id=123
    self.sequence_id= 1
    self.aggregate_id= 456
    super(attrs)
  end

  def replay(aggregate)
    aggregate.event_replayed= true
  end
end