class MessagesController < ApplicationController

  def index
    @messages = Message.where(message_feed_id: params[:message_feed_id]).order(created_at: :asc)
    @feed = MessageFeed.find(params[:message_feed_id])

    @artist = @feed.artist
    @client = @feed.client

    @hide_navbar = true

    if current_user.userable_type == "Client"
      @user = @feed.artist
    elsif current_user.userable_type == "Artist"
      @user = @feed.client
    end
  end

  def create
    @feed = MessageFeed.find(params[:message_feed_id])
    @message = Message.new(message_params)
    @message.message_feed = @feed
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
            locals: { message: @message, now_user: current_user })
        end
        format.html { redirect_to message_feed_path(@feed), notice: "Message envoyé avec succès." }
      end
    else
      redirect_to message_feed_path(@feed), alert: "Erreur lors de l'envoi du message."
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
