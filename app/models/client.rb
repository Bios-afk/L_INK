class Client < ApplicationRecord
  has_one :user, as: :userable, dependent: :destroy
  has_many :quote_requests, dependent: :destroy
  has_many :bookings, through: :quote_requests, dependent: :destroy

  has_many :message_feeds, dependent: :destroy

end
