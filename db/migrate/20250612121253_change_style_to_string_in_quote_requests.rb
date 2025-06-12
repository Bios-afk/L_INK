class ChangeStyleToStringInQuoteRequests < ActiveRecord::Migration[7.1]
  def change
    change_column :quote_requests, :style, :string, using: 'style::text'
  end
end
