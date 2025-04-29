class Room < ApplicationRecord
  belongs_to :hotel
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_one_attached :main_image
  has_many_attached :gallery_images
  
  validates :room_type, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def available?(start_date, end_date)
    bookings.where("(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?)",
      end_date, end_date, # First condition
      start_date, start_date, # Second condition
      start_date, end_date # Third condition
    ).none?
  end
end 