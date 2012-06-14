require "spec_helper"
require_relative "../../../lib/repositories/aggregate_repository"
require_relative "../../../lib/test/fake_aggregate"
require_relative "../../../lib/test/fake_event"
require_relative "../../../lib/broadcasters/void_event_broadcaster"

describe EventStore::AggregateRepository do
  describe "When saving aggregate" do
    before(:each) do
      @events = [FakeEvent.new]
      @event_repo = double("event repo")
      @serialised_aggregate = double("serialised aggregate")
      @event_broadcaster = double("event broadcaster")

      @aggregate_repo = EventStore::AggregateRepository.new(
          event_repository: @event_repo,
          aggregate_accessor: @serialised_aggregate,
          event_broadcaster: @event_broadcaster
      )

      @aggregate = double("aggregate")
    end

    it "should save events and serialised aggregate" do
      @serialised_aggregate.should_receive(:transaction).and_yield

      @serialised_aggregate.should_receive(:from_aggregate).with(@aggregate).and_return @serialised_aggregate
      @serialised_aggregate.should_receive(:save)
      @event_repo.should_receive(:save_all).with @events

      @aggregate.stub(:id => 123)
      @aggregate.stub(:new_events => @events)

      @events.each do |event|
        @event_broadcaster.should_receive(:broadcast).with(event)
      end

      @aggregate_repo.save @aggregate
    end
  end

  describe "When retrieving aggregate by id" do
    before(:each) do
      @event = stub("event")
      event_repo = mock("event repo")
      event_repo.stub(:events_for_aggregate).with(123) { [@event] }

      @event.should_receive(:replay).with(anything) do |agg|
        agg.event_replayed = true
      end

      aggregate_accessor = mock("aggregate accessor")
      aggregate_accessor.should_receive(:with_id).and_return(EventStore::SerialisedAggregate.new({
                                                                                                     :id => 123,
                                                                                                     :aggregate_type => "FakeAggregate"
                                                                                                 }))

      aggregate_repo = EventStore::AggregateRepository.new(
          event_repository: event_repo,
          aggregate_accessor: aggregate_accessor,
          event_broadcaster: EventStore::VoidEventBroadcaster.new
      )

      @aggregate = aggregate_repo.find_aggregate_with_id 123
    end

    it "should replay events" do
      @aggregate.event_replayed.should == true
    end

    it "should load events onto aggregate" do
      loaded_events = @aggregate.loaded_events
      loaded_events.count.should equal 1
      loaded_events.should include @event
    end
  end
end