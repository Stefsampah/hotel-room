class AddCoordinatesToHotels < ActiveRecord::Migration[8.0]
  def change
    add_column :hotels, :latitude, :float
    add_column :hotels, :longitude, :float
  end
end
