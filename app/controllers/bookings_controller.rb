class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:edit, :update, :approve, :reject]
  before_action :authorize_artist_for_update, only: [:edit, :update]
  before_action :authorize_client_for_approval, only: [:approve, :reject]

  def edit
    # @booking déjà chargé via set_booking
  end

  def update
    if @booking.pending_artist_proposal?
      if @booking.update(booking_params)
        @booking.message_feed ||= @booking.create_message_feed!(client: @booking.client, artist: @booking.artist)
        @booking.pending_client_approval!

        @message = @booking.message_feed.messages.create!(
          user: current_user,
          body: render_to_string(partial: "bookings/summary", locals: { booking: @booking, current_user: current_user })
        )

        respond_to do |format|
          format.html { redirect_to message_feed_messages_path(@booking.message_feed), notice: 'Proposition envoyée au client.' }
          format.turbo_stream do
            render turbo_stream: turbo_stream.append("messages", partial: "messages/message", locals: { message: @message, now_user: current_user })
          end
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = 'Erreur dans le formulaire.'
            render :edit, status: :unprocessable_entity
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "booking_form_#{@booking.id}",
              partial: "bookings/form",
              locals: { booking: @booking }
            ), status: :unprocessable_entity
          end
        end
      end
    else
      redirect_to message_feed_path(@booking.message_feed), alert: 'Ce projet ne peut plus être modifié.'
    end
  end

  def approve
    if @booking.pending_client_approval?
      @booking.approved!
      @booking.message_feed ||= @booking.create_message_feed!(client: @booking.client, artist: @booking.artist)

      summary_html = render_to_string(partial: 'bookings/summary', locals: { booking: @booking, current_user: current_user })

      message = @booking.message_feed.messages.create!(
        user: current_user,
        body: summary_html
      )

      respond_to do |format|
        format.html { redirect_to message_feed_path(@booking.message_feed), notice: 'Booking validé avec succès !' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("messages", partial: "messages/message", locals: { message: message })
        end
      end
    else
      redirect_to message_feed_path(@booking.message_feed), alert: 'Booking ne peut pas être validé à ce stade.'
    end
  end

  def reject
    if @booking.pending_client_approval?
      @booking.rejected_by_client!
      redirect_to message_feed_path(@booking.message_feed), notice: 'Proposition de booking refusée.'
    else
      redirect_to message_feed_path(@booking.message_feed), alert: 'Booking ne peut pas être refusé à ce stade.'
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Booking non trouvé.'
  end

  def booking_params
    params.require(:booking).permit(:booking_date, :price, :photo, :status)
  end

  def authorize_artist_for_update
    redirect_to root_path, alert: 'Action non autorisée.' unless current_user.userable_type == "Artist"
  end

  def authorize_client_for_approval
    redirect_to root_path, alert: 'Action non autorisée.' unless current_user.userable_type == "Client"
  end
end
