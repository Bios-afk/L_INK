class MessageFeed < ApplicationRecord

  belongs_to :client
  belongs_to :artist

  has_many :messages, dependent: :destroy

  has_one :booking, dependent: :destroy

  has_one :quote_request, through: :booking

  
end
