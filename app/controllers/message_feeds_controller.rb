class MessageFeedsController < ApplicationController

  def index
    if current_user.userable_type == 'Artist'
      @feeds = current_user.userable.message_feeds
    elsif current_user.userable_type == 'Client'
      @feeds = MessageFeed
              .joins(booking: :quote_request)
              .where(quote_requests: { client_id: current_user.userable_id })
              .distinct
    else
      @feeds = MessageFeed.none
    end
  end

  def show
    @feed = MessageFeed.find(params[:id])

    # Vérifie si le client essaie d'accéder à un chat encore "pending"
    if current_user.userable_type == "Client"
      quote_request = @feed.booking.quote_request

      if quote_request.pending?
        redirect_to message_feeds_path, alert: "Ce chat est en attente d'une réponse de l'artiste."
        return
      end
    end

    @messages = @feed.messages.order(created_at: :asc)
    @message = Message.new
  end

  def destroy
    @feed = MessageFeed.find(params[:id])
    @feed.destroy
    redirect_to message_feeds_path, notice: "Conversation supprimée."
  end
end
