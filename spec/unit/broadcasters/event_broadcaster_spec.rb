require "rspec"
require_relative '../../../lib/broadcasters/event_broadcaster'

describe "Broadcasting an event" do
  it "should notify all event listeners" do
    broadcaster = EventStore::EventBroadcaster.new
    event_listener = mock("mock event listener")
    event = mock("mock event")
    broadcaster.register_listener event_listener

    event_listener.should_receive(:listen_to).with(event)

    broadcaster.broadcast(event)
  end
end