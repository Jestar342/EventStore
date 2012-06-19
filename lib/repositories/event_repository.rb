require_relative '../datamodel/serialised_event'

module EventStore
  class EventRepository
    def initialize(active_record_class=::EventStore::SerialisedEvent)
      @active_record_class = active_record_class
    end

    def save(event)
      serialised_event = @active_record_class.from_event(event)
      serialised_event.save
    end

    def events_for_aggregate(aggregate_id)
      serialised_events = @active_record_class.where(:aggregate_id => aggregate_id).order(:sequence_id)
      serialised_events.collect do | se |
        event = YAML.load se.event_yaml
        event.created = se.created_at
        event
      end
    end

    def save_all(events)
      events.each do | event |
        save event
      end
    end
  end
end