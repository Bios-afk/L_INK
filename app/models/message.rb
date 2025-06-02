class Message < ApplicationRecord
  belongs_to :message_feed

  validates :reader, presence: true
  validates :body, presence: true
end
