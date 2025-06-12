class ChangeStyleStringInQuoteRequests < ActiveRecord::Migration[7.1]
  def change
    remove_column :quote_requests, :style
    add_column :quote_requests, :style, :string, null: false
  end
end
