class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :bio, :string
    add_column :users, :longitute, :float
    add_column :users, :latitude, :float
    add_reference :users, :userable, polymorphic: true, null: false
  end
end
