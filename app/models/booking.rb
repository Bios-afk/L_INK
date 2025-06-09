class Booking < ApplicationRecord
  belongs_to :client
  belongs_to :artist

  belongs_to :quote_request, dependent: :destroy
  belongs_to :message_feed

  has_many :reviews, dependent: :destroy
end
