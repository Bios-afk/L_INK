class MessagesController < ApplicationController

  def index
    @messages = Message.where(message_feed_id: params[:message_feed_id]).order(created_at: :asc)
    @feed = MessageFeed.find(params[:message_feed_id])
    
    @artist = @feed.artist
    @client = @feed.client

    @message = Message.new

    if current_user.userable_type == "Client"
      @user = @feed.artist
    elsif current_user.userable_type == "Artist"
      @user = @feed.client
    end
  end
end
