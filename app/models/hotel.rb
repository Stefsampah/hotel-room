class Hotel < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :bookings, through: :rooms
  has_one_attached :main_image
  has_many_attached :gallery_images

  validates :name, presence: true
  validates :address, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true

  def average_rating
    return 0 if rooms.empty?
    rooms.average(:rating).to_f.round(1)
  end

  def available_rooms_count
    rooms.where(available: true).count
  end
end 