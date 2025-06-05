class Artist < ApplicationRecord
  geocoded_by :address
  has_many_attached :photos, dependent: :destroy

  has_one :user, as: :userable, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :message_feeds, dependent: :destroy

  has_many :reviews


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

end
