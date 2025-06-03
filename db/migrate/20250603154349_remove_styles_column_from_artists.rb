class RemoveStylesColumnFromArtists < ActiveRecord::Migration[7.1]
  def change
    remove_column :artists, :styles, :string
  end
end
