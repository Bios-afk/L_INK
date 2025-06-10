class AddNoteAndNotesCountToArtists < ActiveRecord::Migration[7.1]
  def change
    add_column :artists, :rating, :integer, default: nil
    add_column :artists, :ratings_count, :integer, default: 0, null: false
  end
end
