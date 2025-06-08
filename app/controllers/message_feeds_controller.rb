class MessageFeedsController < ApplicationController

  def index
    @feeds = current_user.userable.message_feeds
  end

  def show
    @feed = MessageFeed.find(params[:id])
    @messages = @feed.messages.order(created_at: :asc)
    @message = Message.new
  end
end
