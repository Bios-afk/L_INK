class Message < ApplicationRecord
  has_many_attached :message_pictures, dependent: :destroy

  belongs_to :message_feed
  belongs_to :user

  validate :body_or_photo_present

  after_update_commit :broadcast_read_status, if: :saved_change_to_read?

  after_create_commit :broadcast_message

  private

  #mise a jour en temps reel du statut de lecture du message
  def broadcast_read_status
    broadcast_replace_to "message_feed_#{message_feed.id}",
      partial: "messages/message",
      target: "message-#{id}",
      locals: { message: self, now_user: user }
  end

  # Validation pour s'assurer qu'un message contient soit du texte, soit une image
  def body_or_photo_present
    if body.blank? && message_pictures.blank?
      errors.add(:base, "Le message doit contenir un texte ou une image.")
    end
  end

  # Diffusion du message dans le flux de messages et la barre de navigation
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
