require 'open-uri'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clean up existing data
puts "Cleaning database..."
Booking.destroy_all
Room.destroy_all
Hotel.destroy_all
User.destroy_all

# Create hotels
puts "Creating hotels..."

hotels_data = [
  {
    name: "Le Grand Palace",
    address: "15 Rue de la Paix, 75002 Paris, France",
    description: "Luxurious 5-star hotel in the heart of Paris with stunning views of the Eiffel Tower.",
    image_url: "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80"
  },
  {
    name: "Seaside Resort",
    address: "123 Ocean Drive, Miami Beach, FL 33139, USA",
    description: "Beautiful beachfront resort with private access to Miami Beach.",
    image_url: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1176&q=80"
  },
  {
    name: "Mountain Lodge",
    address: "789 Alpine Way, Aspen, CO 81611, USA",
    description: "Cozy mountain retreat with ski-in/ski-out access.",
    image_url: "https://images.unsplash.com/photo-1601918774946-25832a4be0d6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1169&q=80"
  }
]

hotels = hotels_data.map do |hotel_data|
  hotel = Hotel.create!(
    name: hotel_data[:name],
    address: hotel_data[:address],
    description: hotel_data[:description]
  )
  # Attach main image from URL
  begin
    file = URI.open(hotel_data[:image_url])
    hotel.main_image.attach(io: file, filename: "#{hotel.name.parameterize}.jpg")
  rescue => e
    puts "Failed to attach image for #{hotel.name}: #{e.message}"
  end
  hotel
end

# Create rooms for each hotel
puts "Creating rooms..."

room_types_data = [
  {
    name: "Standard",
    price: 100,
    image_url: "https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80"
  },
  {
    name: "Deluxe",
    price: 200,
    image_url: "https://images.unsplash.com/photo-1578683010236-d716f9a3f461?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80"
  },
  {
    name: "Suite",
    price: 300,
    image_url: "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80"
  }
]

hotels.each do |hotel|
  room_types_data.each do |room_data|
    room = Room.create!(
      hotel: hotel,
      room_type: room_data[:name],
      price: room_data[:price]
    )
    # Attach main image from URL
    begin
      file = URI.open(room_data[:image_url])
      room.main_image.attach(io: file, filename: "#{room_data[:name].parameterize}.jpg")
    rescue => e
      puts "Failed to attach image for #{room.room_type}: #{e.message}"
    end
  end
end

# Create a test user
puts "Creating test user..."
user = User.create!(
  email: "test@example.com",
  password: "password",
  full_name: "John",
  last_name: "Doe"
)

puts "Finished!"
