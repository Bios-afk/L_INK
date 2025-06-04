class ArtistsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index]
  before_action :ensure_current_user_is_artist!, only: [:edit, :update]
  before_action :set_artist, only: [:edit, :update]

  def index
    if params[:query].present?
    @artists = Artist.joins(:user).where("users.pseudo ILIKE :query OR users.bio ILIKE :query", query: "%#{params[:query]}%")
    else
    @artists = Artist.all
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
