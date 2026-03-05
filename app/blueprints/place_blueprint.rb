class PlaceBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :address, :place_type, :is_vegan, 
         :average_rating, :ratings_count, :schedule, :links, :price_range
         
  association :markers, blueprint: MarkerBlueprint
  association :comments, blueprint: CommentBlueprint
end