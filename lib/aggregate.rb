require_relative "attribute_initialize"

module EventStore
  module Aggregate
    include AttributeInitialize
    attr_accessor :id

    def replay_events (events)
      events.each do |event|
        event.replay self
        self.loaded_events << event
      end
    end

    def new_events
      @new_events ||= []
    end

    def loaded_events
      @loaded_events ||= []
    end

    def next_sequence
      new_events.count + loaded_events.count
    end

    protected

    def record_event (new_event)
      raise "must create aggregate with id before recording events" if id.nil?
      new_event.aggregate_id = self.id
      new_event.sequence_id = next_sequence
      new_events << new_event
      new_event.replay self
    end

  end
end