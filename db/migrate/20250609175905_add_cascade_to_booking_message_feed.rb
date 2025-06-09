class AddCascadeToBookingMessageFeed < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :bookings, :message_feeds
    add_foreign_key :bookings, :message_feeds, on_delete: :cascade
  end
end
