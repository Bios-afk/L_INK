class AddReferencesToBookings < ActiveRecord::Migration[7.1]
  def change
    add_reference :bookings, :quote_request, null: false, foreign_key: true
    add_reference :bookings, :message_feed, null: false, foreign_key: true
  end
end
