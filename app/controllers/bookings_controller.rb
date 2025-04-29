class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :create ]

  def create
    @booking = @room.bookings.build(booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to room_path(@room), notice: 'Réservation créée avec succès.'
    else
      redirect_to room_path(@room), alert: @booking.errors.full_messages.join(", ")
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end 