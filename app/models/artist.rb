class Artist < ApplicationRecord
  geocoded_by :address
  has_many_attached :photos, dependent: :destroy

  has_one :user, as: :userable, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :message_feeds, dependent: :destroy

  has_many :reviews, through: :bookings, dependent: :destroy

  validates :address, presence: true, on: :update
  # validates :longitude, presence: true
  # validates :latitude, presence: true

  after_validation :geocode, if: :will_save_change_to_address?

  def marker_map
    {
      lat: latitude,
      lng: longitude
    }
  end

  def rating
    self.reviews.any? ? self.reviews.average(:rating) : 0
  end

  def distance_to(lat, lon)
    if lat.nil? && lon.nil?
      return ""
    else
      Geocoder::Calculations.distance_between([self.latitude, self.longitude], [lat, lon]).round
    end
  end
end
