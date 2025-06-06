class ArtistsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :ensure_current_user_is_artist!, only: [:edit, :update]
  before_action :set_artist, only: [:edit, :update]

  def index
    @artists = Artist.joins(:user).distinct

    # 🔍 Filtre texte (pseudo ou bio)
    if params[:query].present?
      query = "%#{params[:query]}%"
      @artists = @artists.where("users.pseudo ILIKE ? OR users.bio ILIKE ?", query, query)
    end

    # 🎨 Filtre par catégories
    if params[:category_ids].present?
      @artists = @artists.joins(user: :categories)
                         .where(categories: { id: params[:category_ids] })
                         .distinct
    end

    # 📍 Filtre par villes (dans l'adresse)
    if params[:cities].present?
      city_conditions = params[:cities].map do |city|
        Artist.arel_table[:address].matches("%#{city}%")
      end
      @artists = @artists.where(city_conditions.inject(:or)) if city_conditions.any?
    end

    # ⭐️ Filtre par note moyenne (rating >= ...)
    if params[:rating].present?
      rating_threshold = params[:rating].to_i
      @artists = @artists.joins(:reviews)
                         .group("artists.id")
                         .having("AVG(reviews.rating) >= ?", rating_threshold)
    end
  end

  def edit
    @artist = current_user.userable
    @user = current_user
  end

  def update
    if @artist.update(artist_params)
      redirect_to user_path(current_user), notice: "Profil complété avec succès."
    else
      render :edit
    end
  end

  def show
    @artist = Artist.find(params[:id])
  end

  private

  def set_artist
    @artist = current_user.userable
  end

  def ensure_current_user_is_artist!
    redirect_to root_path unless current_user.userable_type == "Artist"
  end

  def artist_params
    params.require(:artist).permit(:address, :bio)
  end
end
