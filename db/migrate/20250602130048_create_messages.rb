class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.boolean :read
      t.string :body
      t.references :message_feed, null: false, foreign_key: true

      t.timestamps
    end
  end
end
