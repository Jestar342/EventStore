require "spec_helper"
require_relative "../../lib/repositories/event_repository"
require_relative "../../lib/repositories/aggregate_repository"
require_relative "../../lib/datamodel/serialised_event"
require_relative "../../lib/datamodel/serialised_aggregate"
require_relative "../../lib/test/fake_aggregate"
require_relative "../../lib/test/fake_event"
require_relative "../../lib/broadcasters/void_event_broadcaster"

describe EventStore::AggregateRepository do

  describe "When saving and retrieving aggregates" do
    before(:all) do
      ActiveRecord::Base.transaction do
        aggregate_repo = EventStore::AggregateRepository.new
        aggregate = FakeAggregate.new
        aggregate.id = 123

        aggregate.raise_event
        aggregate_repo.save aggregate

        @events_count = EventStore::SerialisedEvent.all.count
        @serialised_aggregates = EventStore::SerialisedAggregate.all

        @retrieved_aggregate = aggregate_repo.find_aggregate_with_id 123

        raise ActiveRecord::Rollback, "Deliberate rollback"
      end
    end

    after(:all) do
      EventStore::SerialisedEvent.delete_all
      EventStore::SerialisedAggregate.delete_all
    end

    it "should save aggregate events" do
      @events_count.should == 1
    end

    it "should save serialised aggregate" do
      @serialised_aggregates.count.should == 1
      @serialised_aggregates[0].id.should == 123
      @serialised_aggregates[0].aggregate_type.should == "FakeAggregate"
    end

    it "should retrieve aggregate by id" do
      @retrieved_aggregate.id.should == 123
      @retrieved_aggregate.class.name.should == "FakeAggregate"
      @retrieved_aggregate.event_replayed.should be(true)
    end
  end
end