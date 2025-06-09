class QuoteRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quote_request, only: [:accept, :reject]
  before_action :authorize_artist!, only: [:index, :accept, :reject]

  def new
    @artist = Artist.find(params[:artist_id])
    @quote_request = QuoteRequest.new
  end

  def create
    artist = Artist.find_by(id: quote_request_params[:artist_id])
    unless artist
      redirect_back fallback_location: root_path, alert: "Artiste invalide." and return
    end

    @quote_request = QuoteRequest.new(quote_request_params)
    @quote_request.client = current_user.userable
    @quote_request.artist = artist

    if @quote_request.save
      redirect_to_conversation(@quote_request)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    # Affiche les demandes de devis en attente pour l'artiste connecté
    @pending_requests = current_user.userable.quote_requests.where(status: :pending)
  end

  def accept
    ActiveRecord::Base.transaction do
      @quote_request.update!(status: :accepted)
      Booking.create!(client: @quote_request.client, artist: @quote_request.artist)
      MessageFeed.find_or_create_by!(client: @quote_request.client, artist: @quote_request.artist)
    end
    redirect_to quote_requests_path, notice: "Demande acceptée et rendez-vous créé."
  rescue ActiveRecord::RecordInvalid
    redirect_to quote_requests_path, alert: "Impossible d'accepter la demande."
  end

  def reject
    if @quote_request.update(status: :rejected)
      redirect_to quote_requests_path, notice: "Demande rejetée."
    else
      redirect_to quote_requests_path, alert: "Impossible de rejeter la demande."
    end
  end

  private

  def set_quote_request
    @quote_request = current_user.userable.quote_requests.find_by(id: params[:id])
    unless @quote_request
      redirect_to quote_requests_path, alert: "Demande non trouvée ou accès refusé."
    end
  end

  def authorize_artist!
    unless current_user.userable_type == "Artist"
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def quote_request_params
    params.require(:quote_request).permit(
      :size,
      :allergies,
      :comments,
      :artist_id,
      style: [],
      color: [],
      body_zone: []
    )
  end

  def redirect_to_conversation(quote)
    artist = quote.artist
    client = quote.client

    feed = MessageFeed.find_or_create_by!(artist: artist, client: client)

    unless feed.messages.exists?(body: quote_summary(quote), user: current_user)
      feed.messages.create!(
        body: quote_summary(quote),
        user: current_user
      )
    end

    redirect_to message_feed_path(feed)
  end

  def quote_summary(quote)
    <<~MSG
      ✏️ Nouvelle demande de devis :
      • Style : #{quote.style.join(', ')}
      • Taille : #{quote.size}
      • Couleur : #{quote.color.join(', ')}
      • Zone : #{quote.body_zone.join(', ')}
      • Allergies : #{quote.allergies}
      • Commentaire : #{quote.comments}
    MSG
  end
end
