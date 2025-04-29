class PagesController < ApplicationController
  def home
    @featured_rooms = Room.includes(:hotel).limit(6)
  end

  def search
    if params[:query].present?
      @hotels = Hotel.search(params[:query])
      @rooms = Room.joins(:hotel).where(hotel: @hotels)
    else
      @hotels = Hotel.all
      @rooms = Room.all
    end
    
    @markers = @hotels.geocoded.map do |hotel|
      {
        lat: hotel.latitude,
        lng: hotel.longitude,
        info_window_html: render_to_string(partial: "shared/info_window", locals: { hotel: hotel })
      }
    end
  end
end
