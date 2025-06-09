class MapsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.latitude.present? && current_user.longitude.present?
      @user_lat = current_user.latitude
      @user_lng = current_user.longitude
    else
      @user_lat = 44.837789  # Bordeaux par défaut
      @user_lng = -0.57918
    end

    radius = 10 # km

    # On construit la requête avec select explicite
    @artists = Artist
      .select("artists.*, #{Artist.distance_sql(@user_lat, @user_lng)} AS distance")
      .near([@user_lat, @user_lng], radius)
      .order("distance ASC")

    # Récupérer les users associés aux artistes dans la zone
    artist_ids = @artists.map(&:id)
    @users = User.where(userable_type: "Artist", userable_id: artist_ids)
                 .where.not(id: current_user.id)
  end
end
