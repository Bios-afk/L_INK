class QuoteRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quote_request, only: [:accept, :reject]
  before_action :authorize_artist!, only: [:index, :accept, :reject]

  def new
    @artist = Artist.find(params[:artist_id])
    @quote_request = QuoteRequest.new
  end

  def create
    @quote_request = QuoteRequest.new(quote_request_params)
    @quote_request.client = current_user.userable

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
    if @quote_request.update(status: :accepted)
      Booking.create!(
        client: @quote_request.client,
        artist: @quote_request.artist
      )
      MessageFeed.find_or_create_by(client: @quote_request.client, artist: @quote_request.artist)
      redirect_to quote_requests_path, notice: "Demande acceptée et rendez-vous créé."
    else
      redirect_to quote_requests_path, alert: "Impossible d'accepter la demande."
    end
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
    @quote_request = QuoteRequest.find(params[:id])
  end

  def authorize_artist!
    # Sécurité : ne montrer que les demandes qui appartiennent à l'artiste connecté
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
      • Style : #{quote.style}
      • Taille : #{quote.size}
      • Couleur : #{quote.color}
      • Zone : #{quote.body_zone}
      • Allergies : #{quote.allergies}
      • Commentaire : #{quote.comments}
    MSG
  end
end
