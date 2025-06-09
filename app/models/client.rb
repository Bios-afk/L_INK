class Client < ApplicationRecord
  has_one :user, as: :userable, dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_many :message_feeds, dependent: :destroy

end
