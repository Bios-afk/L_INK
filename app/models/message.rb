class Message < ApplicationRecord
  has_many_attached :message_pictures, dependent: :destroy

  belongs_to :message_feed
  belongs_to :user

  validate :body_or_photo_present

  after_create_commit :broadcast_message

  private

  def body_or_photo_present
    if body.blank? && message_pictures.blank?
      errors.add(:base, "Le message doit contenir un texte ou une image.")
    end
  end

  def broadcast_message
    broadcast_append_to "message_feed_#{message_feed.id}",
                        partial: "messages/message",
                        target: "messages",
                        locals: { message: self, now_user: user }

    broadcast_append_to "navbar_stream_#{message_feed.client.user.id}",
                        partial: "shared/pastille_notif",
                        target: "pastille-notif"

    broadcast_append_to "navbar_stream_#{message_feed.artist.user.id}",
                        partial: "shared/pastille_notif",
                        target: "pastille-notif"

  end
end
