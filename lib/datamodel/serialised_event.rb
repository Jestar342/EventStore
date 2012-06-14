module EventStore
  class SerialisedEvent < ActiveRecord::Base
    attr_accessible :event_yaml, :id, :sequence_id, :aggregate_id

    def self.from_event(event)
      return SerialisedEvent.new ({
          :id => event.id,
          :sequence_id => event.sequence_id,
          :aggregate_id => event.aggregate_id,
          :event_yaml => event.to_yaml
      })
    end
  end
end
