class Booking < ApplicationRecord
  belongs_to :client
  belongs_to :artist
  belongs_to :quote_request
  belongs_to :message_feed, optional: true  # temporairement optionnel

  has_one_attached :photo
  has_many :reviews, dependent: :destroy

  enum status: {
    pending_artist_proposal: 0,
    pending_client_approval: 1,
    approved: 2,
    rejected_by_client: 3,
    cancelled_by_artist: 4,
    completed: 5,
    archived: 6
  }

  with_options if: -> { pending_client_approval? || approved? } do
    validates :booking_date, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
  end

  after_initialize :build_message_feed_if_nil

  def build_message_feed_if_nil
    if self.new_record? && self.message_feed.nil? && self.client && self.artist
      build_message_feed(client: client, artist: artist)
    end
  end
end
