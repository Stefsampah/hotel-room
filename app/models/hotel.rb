class Hotel < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_one_attached :main_image
  has_many_attached :gallery_images
  
  validates :name, presence: true
  validates :address, presence: true
  
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  
  def self.search(query)
    if query.present?
      where('name LIKE ? OR address LIKE ?', "%#{query}%", "%#{query}%")
    else
      all
    end
  end
end
