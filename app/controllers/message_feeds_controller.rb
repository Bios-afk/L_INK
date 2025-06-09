class MessageFeedsController < ApplicationController

  def index
    if current_user.userable_type == 'Artist'
      @feeds = current_user.userable.message_feeds
    elsif current_user.userable_type == 'Client'
      @feeds = MessageFeed
              .joins(booking: :quote_request)
              .where(quote_requests: { status: :accepted })
              .distinct
    else
      @feeds = MessageFeed.none
    end
  end

  def show
    @feed = MessageFeed.find(params[:id])
    @messages = @feed.messages.order(created_at: :asc)
    @message = Message.new
  end

  def destroy
    @feed = MessageFeed.find(params[:id])
    @feed.destroy
    redirect_to message_feeds_path, notice: "Conversation supprimée."
  end
end
