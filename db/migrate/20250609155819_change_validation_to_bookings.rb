class ChangeValidationToBookings < ActiveRecord::Migration[7.1]
  def change
    change_column_null :bookings, :message_feed_id, true
  end
end
