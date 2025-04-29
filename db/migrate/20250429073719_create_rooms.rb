class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.references :hotel, null: false, foreign_key: true
      t.string :room_type
      t.decimal :price

      t.timestamps
    end
  end
end
