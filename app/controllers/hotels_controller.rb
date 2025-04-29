class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]

  def index
    @hotels = Hotel.all
  end

  def show
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      redirect_to @hotel, notice: 'Hotel was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @hotel.update(hotel_params)
      redirect_to @hotel, notice: 'Hotel was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @hotel.destroy
    redirect_to hotels_url, notice: 'Hotel was successfully deleted.'
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def hotel_params
    params.require(:hotel).permit(:name, :address, :description)
  end
end
