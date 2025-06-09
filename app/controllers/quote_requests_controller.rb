class QuoteRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quote_request, only: [:accept, :reject]

  def new
    @artist = Artist.find(params[:artist_id])
    @quote_request = QuoteRequest.new
  end

  def create
    @quote_request = QuoteRequest.new(quote_request_params)
    @quote_request.client = current_user.userable

    if @quote_request.save
      Rails.logger.info "QuoteRequest saved: #{@quote_request.id}"
      redirect_to_conversation(@quote_request)
    else
      Rails.logger.warn "QuoteRequest failed: #{@quote_request.errors.full_messages.join(', ')}"
      @artist = Artist.find(quote_request_params[:artist_id])
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @pending_requests = current_user.userable.quote_requests.pending
  end

  def accept

    if @quote_request.update(status: :accepted)
      feed = MessageFeed.find_or_create_by!(artist: @quote_request.artist, client: @quote_request.client)
      redirect_to message_feed_path(feed), notice: "Demande acceptée et rendez-vous créé."
    else
      redirect_to message_feed_path(feed), alert: "Impossible d'accepter la demande."
    end
  end

  def reject
    if @quote_request.update(status: :rejected)
      redirect_to message_feeds_path, notice: "Demande rejetée."
    else
      redirect_to message_feeds_path, alert: "Impossible de rejeter la demande."
    end
  end

  private

  def set_quote_request
    @quote_request = QuoteRequest.find(params[:id])
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

    feed = MessageFeed.find_or_create_by!(artist: quote.artist, client: quote.client)

    @booking = Booking.new(
      client: @quote_request.client,
      artist: @quote_request.artist,
      quote_request: @quote_request,
      message_feed: feed
      )
    @booking.save!
    
    unless feed.messages.exists?(body: quote_summary(quote), user: current_user)
      feed.messages.create!(body: quote_summary(quote), user: current_user)
    end

    redirect_to artist_path(quote.artist), notice: "Demande de devis envoyée avec succès."
  end

  def quote_summary(quote)
    ApplicationController.renderer.render(partial: 'quote_requests/summary', locals: { quote: quote })
  end
end
