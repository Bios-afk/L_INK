class RemoveDefaultFromStyleInQuoteRequests < ActiveRecord::Migration[7.1]
  def change
    change_column_default :quote_requests, :style, from: [], to: nil
  end
end
