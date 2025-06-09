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
    self.reviews.any? ? self.reviews.average(:rating) : rand(1..5)
  end

  def distance_to(lat, lon)
  Rails.logger.debug "[DISTANCE DEBUG] lat: #{lat}, lon: #{lon}, self: #{self.latitude}, #{self.longitude}"
  if lat.nil? || lon.nil? || self.latitude.nil? || self.longitude.nil?
    nil
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
