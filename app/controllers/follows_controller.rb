class FollowsController < ApplicationController
  before_action :authenticate_user!

  def index
    @followed_artists = current_user.followed_artists.includes(:user) # pour charger aussi leur user (pseudo, bio…)
    @follows_count = @followed_artists.size
  end

  def create
    artist = Artist.find(params[:artist_id])
    current_user.follows.find_or_create_by(artist:)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: artist_path(artist) }
    end
  end

  def destroy
    # on récupère le Follow par son propre ID (via follow_path(follow))
    follow = current_user.follows.find(params[:id])
    follow.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: artist_path(follow.artist) }
    end
  end
end
