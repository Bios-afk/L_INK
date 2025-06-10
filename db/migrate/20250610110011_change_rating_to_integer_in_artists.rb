class ChangeRatingToIntegerInArtists < ActiveRecord::Migration[7.1]
  def change
        change_column :artists, :rating, :integer, using: 'rating::integer'
  end
end
