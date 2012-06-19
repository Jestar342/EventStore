class CreateSerialisedEvents < ActiveRecord::Migration
  def up
    create_table :serialised_events do |t|
      t.column :id, :integer, primary: true
      t.column :event_type, :string
      t.column :event_yaml, :text
      t.column :sequence_id, :binary, :null => false
      t.column :aggregate_id, :integer, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :serialised_events
  end
end
