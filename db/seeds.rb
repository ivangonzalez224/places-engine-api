require 'open-uri'
require 'json'

def fetch_json(url)
  JSON.parse(URI.open(url).read)["data"]
end

# Helper to split "4.8 - 5" into [4.8, 5]
def parse_rating_string(rating_str)
  return [0.0, 0] if rating_str.blank? || !rating_str.include?(" - ")
  
  parts = rating_str.split(" - ")
  avg = parts[0].to_f
  count = parts[1].to_i
  [avg, count]
end

puts "Cleaning database..."
Comment.destroy_all
Marker.destroy_all
Place.destroy_all

puts "Fetching data..."
details_url = "https://script.google.com/macros/s/AKfycbymhgvxrtY2WSeT8rOLBfBKuixn_-GoFZU4B-hm-cJZMFEGKornDZJ3Qs942UwblOMY/exec"
locations_url = "https://script.google.com/macros/s/AKfycbwGwlhTDu3NohTeYUcPKFlmsz69jQR3UZwtqdd_8WraQSt5WiR5KZGnaW6LP56jqEh6vw/exec"
comments_url = "https://script.google.com/macros/s/AKfycbyuic7B0dxSPttxfOB4K_aLzgL_SqOUJ621sd6W0rUvnPVwDhKhh4qEt3dbecUjXhg1/exec"

details_data = fetch_json(details_url)
locations_data = fetch_json(locations_url)
comments_data = fetch_json(comments_url)

places_map = {}

puts "Importing Places with Weighted Ratings..."
details_data.each do |row|
  # Logic for RESTAURANT
  if row["nom_resto"].present?
    avg, count = parse_rating_string(row["rating_resto"])
    
    place = Place.create!(
      name: row["nom_resto"],
      description: row["descri_resto"],
      address: row["direc_resto"],
      place_type: :resto,
      average_rating: avg,
      ratings_count: count,
      schedule: { info: row["hor_restos"] },
      links: { urls: row["links_resto"]&.split("**") },
      is_vegan: row["sello_resto"]&.include?("vegano")
    )
    places_map[row["nom_resto"]] = place
  end

  # Logic for STORE
  if row["nom_tienda"].present? && row["nom_tienda"] != row["nom_resto"]
    avg, count = parse_rating_string(row["rating_tienda"])

    place = Place.create!(
      name: row["nom_tienda"],
      description: row["descri_tienda"],
      address: row["direc_tienda"],
      place_type: :tienda,
      average_rating: avg,
      ratings_count: count,
      schedule: { info: row["hor_tienda"] },
      links: { urls: row["links_tienda"]&.split("**") }
    )
    places_map[row["nom_tienda"]] = place
  end
end

puts "Importing Markers..."
locations_data.each do |loc|
  place = places_map[loc["name"]]
  Marker.create!(lat: loc["lat"], lng: loc["lng"], city_code: loc["city_code"], place: place) if place
end

puts "Importing Comments..."
comments_data.each do |com|
  place = places_map[com["lugar"]]
  if place
    Comment.create!(
      content: com["comment"],
      user_name: com["user"],
      image_url: com["image"],
      user_pic: com["userpic"],
      place: place
    )
  end
end

puts "Success: #{Place.count} Places created with weighted rating metadata."
