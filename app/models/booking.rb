class Booking < ApplicationRecord
  belongs_to :client
  belongs_to :artist

  has_many :reviews, dependent: :destroy
end
