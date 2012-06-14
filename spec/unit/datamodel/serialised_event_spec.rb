require "spec_helper"
require_relative "../../../lib/datamodel/serialised_event"
require_relative "../../../lib/test/fake_event"

describe "When serialising event" do
  before(:each) do
    @event = FakeEvent.new
    @serialised_event = EventStore::SerialisedEvent.from_event @event
  end

  it "should serialise event" do
    @serialised_event.event_yaml.should == @event.to_yaml
  end

  it "should save aggregate id" do
    @serialised_event.aggregate_id.should == @event.aggregate_id
  end

  it "should save sequence id" do
    @serialised_event.sequence_id == @event.sequence_id
  end
end