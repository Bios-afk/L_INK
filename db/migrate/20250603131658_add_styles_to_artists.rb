class AddStylesToArtists < ActiveRecord::Migration[7.1]
  def change
    add_column :artists, :styles, :string
  end
end
