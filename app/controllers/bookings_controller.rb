class BookingsController < ApplicationController
# Ensure the user is logged in for all booking actions
  before_action :authenticate_user!
  # Find the booking before actions that need it
  before_action :set_booking, only: [:update, :approve, :reject]
  # Custom authorization filters
  before_action :authorize_artist_for_update, only: [:update]
  before_action :authorize_client_for_approval, only: [:approve, :reject]

  # Action for artists to propose date, price, and add a photo
  def update
    # Ensure the booking is in a state where an artist can propose
    if @booking.pending_artist_proposal?
      # Attempt to update the booking with parameters provided by the artist
      if @booking.update(booking_params)
        # If successful, change the status to pending client approval
        @booking.pending_client_approval!
        # Redirect with a success notice
        redirect_to @booking, notice: 'Proposal sent to client successfully.'
      else
        # If update fails, re-render the form with errors
        render :edit, status: :unprocessable_entity, alert: 'Could not send proposal. Please check the details.'
      end
    else
      # If the booking is not in the correct state for a proposal
      redirect_to @booking, alert: 'Booking cannot be updated at this stage.'
    end
  end

  # Action for clients to approve a booking proposal
  def approve
    # Ensure the booking is awaiting client approval
    if @booking.pending_client_approval?
      # Change the status to approved
      @booking.approved!
      # Redirect with a success notice
      redirect_to @booking, notice: 'Booking approved successfully!'
    else
      # If the booking is not in the correct state for approval
      redirect_to @booking, alert: 'Booking cannot be approved at this stage.'
    end
  end

  # Action for clients to reject a booking proposal
  def reject
    # Ensure the booking is awaiting client approval
    if @booking.pending_client_approval?
      # Change the status to rejected by client
      @booking.rejected_by_client!
      # Redirect with a success notice
      redirect_to @booking, notice: 'Booking proposal rejected.'
    else
      # If the booking is not in the correct state for rejection
      redirect_to @booking, alert: 'Booking cannot be rejected at this stage.'
    end
  end

  private

  # Set the booking instance based on the ID from parameters
  def set_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # Handle case where booking is not found
    redirect_to root_path, alert: 'Booking not found.'
  end

  # Strong parameters for booking updates (date, price, photo)
  def booking_params
    params.require(:booking).permit(:booking_date, :price, :photo)
  end

  # Authorization method to ensure only artists can update a booking
  def authorize_artist_for_update
    # Check if the current user is an artist
    unless current_user.userable_type == "Artist"
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  # Authorization method to ensure only clients can approve or reject a booking
  def authorize_client_for_approval
    # Check if the current user is a client
    unless current_user.userable_type == "Client"
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

end
