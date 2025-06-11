class Booking < ApplicationRecord
  belongs_to :client
  belongs_to :artist
  has_one_attached :photo

  belongs_to :quote_request, dependent: :destroy
  belongs_to :message_feed

  has_many :reviews, dependent: :destroy

  enum status: {
    pending_artist_proposal: 0,
    pending_client_approval: 1,
    approved: 2,
    rejected_by_client: 3, # Client declines the proposal
    cancelled_by_artist: 4, # Artist cancels before client approval
    completed: 5,
    archived: 6
  }

  # Add validations for date, price, and photo presence when status is 'approved'
  validates :booking_date, presence: true, if: :approved?
  validates :price, presence: true, numericality: { greater_than: 0 }, if: :approved?
  validates :photo, presence: true, if: :approved? # For Active Storage attachment

end
