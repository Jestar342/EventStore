require 'spec_helper'
require File.expand_path('../../../lib/repositories/event_repository', __FILE__)
require File.expand_path('../../../lib/datamodel/serialised_event', __FILE__)
require File.expand_path('../../../lib/test/fake_event', __FILE__)

describe "When Saving And Retrieving Events" do

  before(:all) do
    ActiveRecord::Base.transaction do

      repo = EventStore::EventRepository.new
      event = FakeEvent.new
      repo.save event

      irrelevant_event = FakeEvent.new
      irrelevant_event.id = 2
      irrelevant_event.aggregate_id = 2
      repo.save irrelevant_event

      @all_events = EventStore::SerialisedEvent.all
      @events_for_aggregate = repo.events_for_aggregate(456).count

      raise ActiveRecord::Rollback, "Deliberate rollback"
    end
  end

  it "should retrieve relevant events" do
    @events_for_aggregate.should == 1
  end

  it "should save all events" do
    @all_events.count.should == 2
  end
end