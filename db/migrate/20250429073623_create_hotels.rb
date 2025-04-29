class CreateHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :address
      t.text :description

      t.timestamps
    end
  end
end
