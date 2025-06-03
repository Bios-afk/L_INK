class RenameLongituteToLongitudeInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :longitute, :longitude
  end
end
