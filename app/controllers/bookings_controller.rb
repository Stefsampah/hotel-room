class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :confirmation, :cancel]
  before_action :set_hotel_and_room, only: [:new, :create, :check_availability]

  def index
    @bookings = current_user.bookings.includes(room: :hotel).order(created_at: :desc)
  end

  def show
  end

  def new
    @booking = @room.bookings.build
  end

  def create
    @booking = @room.bookings.build(booking_params)
    @booking.user = current_user

    if booking_params[:start_date].blank? || booking_params[:end_date].blank?
      redirect_to hotel_room_path(@hotel, @room), alert: "Veuillez sélectionner les dates d'arrivée et de départ"
      return
    end

    begin
      start_date = Date.parse(booking_params[:start_date])
      end_date = Date.parse(booking_params[:end_date])

      if start_date < Date.today
        redirect_to hotel_room_path(@hotel, @room), alert: "La date d'arrivée ne peut pas être dans le passé"
        return
      end

      if end_date <= start_date
        redirect_to hotel_room_path(@hotel, @room), alert: "La date de départ doit être après la date d'arrivée"
        return
      end

      unless @room.available?(start_date, end_date)
        redirect_to hotel_room_path(@hotel, @room), alert: "La chambre n'est pas disponible pour ces dates"
        return
      end

      @booking.total_price = calculate_total_price(start_date, end_date)
      if @booking.save
        redirect_to confirmation_hotel_room_booking_path(@hotel, @room, @booking), notice: 'Réservation créée avec succès.'
      else
        redirect_to hotel_room_path(@hotel, @room), alert: @booking.errors.full_messages.join(", ")
      end
    rescue Date::Error
      redirect_to hotel_room_path(@hotel, @room), alert: "Les dates sélectionnées ne sont pas valides"
    end
  end

  def confirmation
    @hotel = @booking.room.hotel
    @room = @booking.room
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Réservation mise à jour avec succès.'
    else
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Réservation supprimée avec succès.'
  end

  def cancel
    if @booking.start_date > Date.today
      @booking.update(status: 'cancelled')
      redirect_to bookings_path, notice: 'Réservation annulée avec succès.'
    else
      redirect_to bookings_path, alert: 'Impossible d\'annuler une réservation passée.'
    end
  end

  def check_availability
    begin
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      
      if start_date < Date.today
        render json: { 
          error: "La date d'arrivée ne peut pas être dans le passé"
        }, status: :unprocessable_entity
        return
      end

      if end_date <= start_date
        render json: { 
          error: "La date de départ doit être après la date d'arrivée"
        }, status: :unprocessable_entity
        return
      end
      
      is_available = @room.available?(start_date, end_date)
      total_price = calculate_total_price(start_date, end_date)
      
      render json: { 
        available: is_available,
        total_price: total_price,
        nights: (end_date - start_date).to_i
      }
    rescue Date::Error
      render json: { 
        error: "Les dates sélectionnées ne sont pas valides"
      }, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:id])
  end

  def set_hotel_and_room
    @hotel = Hotel.find(params[:hotel_id])
    @room = @hotel.rooms.find(params[:room_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def calculate_total_price(start_date = nil, end_date = nil)
    start_date ||= Date.parse(params[:booking][:start_date])
    end_date ||= Date.parse(params[:booking][:end_date])
    nights = (end_date - start_date).to_i
    nights * @room.price
  end
end
