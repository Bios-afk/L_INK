class CreateQuoteRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :quote_requests do |t|
      t.references :client, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
      t.jsonb :style, null: false, default: []
      t.jsonb :color, null: false, default: []
      t.string :size
      t.jsonb :body_zone, null: false, default: []
      t.string :allergies
      t.text :comments
      t.integer :status, null: false, default: 0 # 0 = pending par défaut
      t.timestamps
    end
  end
end
