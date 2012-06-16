module EventStore
  class SerialisedAggregate < ::ActiveRecord::Base
    attr_accessible :aggregate_type, :id

    def self.from_aggregate(aggregate)
      found = with_id(aggregate.id)

      return SerialisedAggregate.create({
                                             id: aggregate.id,
                                             aggregate_type: aggregate.class.name,
                                         }) if found.nil?

      found
    end

    def self.with_id(id)
      aggregates = where(:id => id)
      raise "Many aggregates with same ID found - this is a serious error!" if aggregates.many?
      return nil if !aggregates.any?
      return aggregates[0]
    end
  end
end