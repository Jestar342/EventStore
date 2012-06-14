require_relative '../datamodel/serialised_aggregate'
require_relative '../broadcasters/void_event_broadcaster'
require_relative 'event_repository'

module EventStore
  class AggregateRepository
    def self.defaults
      {
          event_repository: ::EventStore::EventRepository.new,
          aggregate_accessor: ::EventStore::SerialisedAggregate,
          event_broadcaster: ::EventStore::EventBroadcaster.new
      }
    end

    def initialize (opts = {})
      merged = self.class.defaults.merge(opts)
      @event_repository = merged[:event_repository]
      @aggregate_accessor = merged[:aggregate_accessor]
      @event_broadcaster = merged[:event_broadcaster]
    end

    def save (aggregate)
      @aggregate_accessor.transaction do
        serialised_aggregate = @aggregate_accessor.from_aggregate aggregate
        serialised_aggregate.save
        events = aggregate.new_events
        @event_repository.save_all events
        events.each do |event|
          @event_broadcaster.broadcast event
        end
      end
    end

    def find_aggregate_with_id(id)
      serialised_aggregate = @aggregate_accessor.with_id id

      aggregate = Kernel.const_get(serialised_aggregate.aggregate_type).new

      aggregate.id= id

      aggregate.replay_events @event_repository.events_for_aggregate id

      aggregate
    end
  end
end