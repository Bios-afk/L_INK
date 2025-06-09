class Message < ApplicationRecord
  belongs_to :message_feed
  belongs_to :user

  validates :body, presence: true
end
