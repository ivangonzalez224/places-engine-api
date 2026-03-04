class AddRatingMetadataToPlaces < ActiveRecord::Migration[7.1]
  def change
		  add_column :places, :average_rating, :decimal, precision: 3, scale: 2, default: 0.0
		  add_column :places, :ratings_count, :integer, default: 0
		  remove_column :places, :rating, :decimal
		end
end
