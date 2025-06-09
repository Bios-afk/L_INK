class Message < ApplicationRecord
  belongs_to :message_feed
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "message_feed_#{message_feed.id}",
                        partial: "messages/message",
                        target: "messages",
                        locals: { message: self, now_user: user }
  end
end
