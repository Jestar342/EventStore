class CreateBooks < ActiveRecord::Migration
  def up
    create_table :books do | t |
      t.column :id, :binary, primary: true
      t.column :title, :string, null: false
      t.column :author, :string
    end
  end

  def down
    drop_table :books
  end
end
