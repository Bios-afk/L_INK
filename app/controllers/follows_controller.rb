class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    artist = Artist.find(params[:artist_id])
    current_user.follows.find_or_create_by(artist:)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: artist_path(artist) }
    end
  end

  def destroy
    current_user.follows.find_by(artist_id: params[:artist_id])&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: artist_path(params[:artist_id]) }
    end
  end
end
