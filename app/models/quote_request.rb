class QuoteRequest < ApplicationRecord
  belongs_to :client
  belongs_to :artist

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  validates :style, :color, :body_zone, presence: true
end
