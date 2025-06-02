class CreateMessageFeeds < ActiveRecord::Migration[7.1]
  def change
    create_table :message_feeds do |t|
      t.references :client, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
