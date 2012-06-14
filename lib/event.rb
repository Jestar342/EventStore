require "attribute_initialize"

module EventStore
  module Event
    include AttributeInitialize
    attr_accessor :id, :sequence_id, :aggregate_id
  end
end