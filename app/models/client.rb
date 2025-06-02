class Client < ApplicationRecord
  has_one :user, as: :userable
  has_many :bookings, dependent: :destroy
  has_many :message_feeds, dependent: :destroy
end
