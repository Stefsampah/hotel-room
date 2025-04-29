class RoomsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :set_room, only: [ :show ]

  def index
    @rooms = Room.all
  end

  def show
    @booking = @room.bookings.build
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end
end 