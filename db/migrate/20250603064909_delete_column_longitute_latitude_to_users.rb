class DeleteColumnLongituteLatitudeToUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :longitute, :float
    remove_column :users, :latitude, :float
  end
end
