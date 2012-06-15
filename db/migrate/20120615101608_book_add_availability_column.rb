class BookAddAvailabilityColumn < ActiveRecord::Migration
  def up
    change_table :books do | t |
      t.column :available, :boolean, default: true
    end
  end

  def down
    change_table :books do |t|
      t.remove :available
    end
  end
end
