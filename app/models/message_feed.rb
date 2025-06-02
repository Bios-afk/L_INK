class MessageFeed < ApplicationRecord
  belongs_to :client
  belongs_to :artist

  has_many :messages, dependent: :destroy
end
