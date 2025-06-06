class MapsController < ApplicationController
  def show
    # Coordonnées centrées sur Bordeaux (à adapter si besoin)
    @user_lat = 44.8378
    @user_lng = -0.5792

    # Récupère tous les artistes avec latitude et longitude renseignés
    @artists = User.includes(:userable)
               .where(userable_type: "Artist")
               .where.not(latitude: nil, longitude: nil)
  end
end
