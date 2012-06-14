require "spec_helper"
require_relative "../../../lib/datamodel/serialised_aggregate"
require_relative "../../../lib/test/fake_aggregate"

describe "When serialising aggregates" do
  before(:all) do
    @aggregate = FakeAggregate.new
    @serialised = EventStore::SerialisedAggregate.from_aggregate @aggregate
  end

  it "should save id of aggregate" do
    @serialised.id.should == @aggregate.id
  end

  it "should save type of aggregate" do
    @serialised.aggregate_type.should == "FakeAggregate"
  end
end