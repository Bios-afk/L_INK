class MessagesController < ApplicationController

  def index
    @feed = MessageFeed.find(params[:message_feed_id])

    if current_user.userable_type == "Client"
      @user = @feed.artist
    elsif current_user.userable_type == "Artist"
      @user = @feed.client
    end
  end
end
