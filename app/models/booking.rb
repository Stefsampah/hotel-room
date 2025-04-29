class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  validates :start_date, :end_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled] }
  validate :end_date_after_start_date
  validate :dates_cannot_be_in_the_past
  validate :room_must_be_available
  validate :dates_cannot_be_empty
  
  before_validation :set_default_status, on: :create
  before_validation :calculate_total_price, on: :create
  
  private
  
  def set_default_status
    self.status ||= 'pending'
  end

  def calculate_total_price
    return if start_date.blank? || end_date.blank? || room.blank?
    nights = (end_date - start_date).to_i
    self.total_price = nights * room.price
  end
  
  def dates_cannot_be_empty
    if start_date.blank?
      errors.add(:start_date, "ne peut pas être vide")
    end
    
    if end_date.blank?
      errors.add(:end_date, "ne peut pas être vide")
    end
  end
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date < start_date
      errors.add(:end_date, "doit être après la date d'arrivée")
    end
  end
  
  def dates_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "ne peut pas être dans le passé")
    end
    
    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "ne peut pas être dans le passé")
    end
  end
  
  def room_must_be_available
    return if room.nil? || start_date.nil? || end_date.nil?
    
    overlapping_bookings = room.bookings
                              .where.not(id: id)
                              .where('(start_date <= ? AND end_date >= ?) OR
                                     (start_date <= ? AND end_date >= ?) OR
                                     (start_date >= ? AND end_date <= ?)',
                                     start_date, start_date,
                                     end_date, end_date,
                                     start_date, end_date)
    
    if overlapping_bookings.exists?
      errors.add(:base, "La chambre n'est pas disponible pour ces dates")
    end
  end
end 