class CreateMarkers < ActiveRecord::Migration[7.1]
  def change
    create_table :markers do |t|
      t.decimal :lat
      t.decimal :lng
      t.string :city_code
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end
    add_index :markers, :city_code
  end
end
