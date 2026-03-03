class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :name
      t.text :description
      t.string :address
      t.integer :place_type, default: 0
      t.boolean :is_vegan, default: false
      t.decimal :rating, precision: 3, scale: 2
      t.jsonb :schedule, default: {}
      t.jsonb :links, default: {}
      t.string :price_range

      t.timestamps
    end
  end
end
