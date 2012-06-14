require "spec_helper"
require_relative "../../../lib/repositories/event_repository"
require_relative "../../../lib/datamodel/serialised_event"
require_relative "../../../lib/test/fake_event"

describe "When retrieving events for an aggregate" do

  it "should get events from accessor" do
    mock_accessor = mock("accessor")
    event = FakeEvent.new

    mock_accessor.should_receive(:where, :aggregate_id => event.aggregate_id).and_return(mock_accessor)
    mock_accessor.should_receive(:order).with(:sequence_id).and_return([(EventStore::SerialisedEvent.from_event event)])

    repo = EventStore::EventRepository.new mock_accessor

    events_for_aggregate = repo.events_for_aggregate(event.aggregate_id)
    events_for_aggregate.count.should == 1
    events_for_aggregate[0].id.should == event.id
  end
end

describe "When saving events" do

  it "should save serialised event" do
    mock_accessor = mock("accessor")
    mock_serialised_event = mock("serialised event")
    mock_accessor.stub(:from_event) { mock_serialised_event }

    mock_serialised_event.should_receive(:save)

    repo = EventStore::EventRepository.new mock_accessor
    repo.save FakeEvent.new
  end

end