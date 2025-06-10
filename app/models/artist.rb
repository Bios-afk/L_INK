class Artist < ApplicationRecord
  geocoded_by :address
  has_many_attached :photos, dependent: :destroy

  has_one :user, as: :userable, dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_many :message_feeds, dependent: :destroy
  has_many :reviews, through: :bookings, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followers, through: :follows, source: :user

  validates :address, presence: true, on: :update
  # validates :longitude, presence: true
  # validates :latitude, presence: true

  after_validation :geocode, if: :will_save_change_to_address?
  # after_validation :sync_user_coordinates, if: -> { saved_change_to_latitude? || saved_change_to_longitude? }

  def marker_map
    {
      lat: latitude,
      lng: longitude
    }
  end

  def rating
    read_attribute(:rating) || 0
  end

  def distance_to(lat, lon)
    if lat.nil? && lon.nil?
      ""
    else
      Geocoder::Calculations.distance_between([self.latitude, self.longitude], [lat, lon]).round
    end
  end

  # private

  # def sync_user_coordinates
  #   return unless user.present?
  #   user.update(latitude: latitude, longitude: longitude)
  # end
end
