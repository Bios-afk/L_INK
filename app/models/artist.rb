class Artist < ApplicationRecord
  geocoded_by :address

  has_one :user, as: :userable
  has_many :bookings, dependent: :destroy
  has_many :message_feeds, dependent: :destroy

  validates :address, presence: true
  # validates :longitude, presence: true
  # validates :latitude, presence: true

  after_validation :geocode, if: :will_save_change_to_address?
end
