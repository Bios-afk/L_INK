class Booking < ApplicationRecord
  belongs_to :client
  belongs_to :artist

  belongs_to :quote_request
  belongs_to :message_feed, optional: true

  has_many :reviews, dependent: :destroy
end
