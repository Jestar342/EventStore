class CreateSerialisedAggregates < ActiveRecord::Migration
  def up
    create_table :serialised_aggregates do |t|
      t.column :id, :integer, null: false, primary: true
      t.column :aggregate_type, :string, null: false

      t.timestamps
    end
  end

  def down
    drop_table :serialised_aggregates
  end
end
