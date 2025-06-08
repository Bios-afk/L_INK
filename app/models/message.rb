class Message < ApplicationRecord
  belongs_to :message_feed
  belongs_to :user

  validates :reader, presence: true
  validates :body, presence: true
end
