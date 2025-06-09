class AddFollowsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
