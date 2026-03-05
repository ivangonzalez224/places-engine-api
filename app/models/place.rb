class Place < ApplicationRecord
  # Relationships
  has_many :markers, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  # This maps 0 to 'resto' and 1 to 'tienda' in the database
  enum place_type: { resto: 0, tienda: 1 }

  # Validations
  validates :name, :place_type, presence: true

  # Scopes for clean API queries
  scope :vegan, -> { where(is_vegan: true) }
  scope :by_city, ->(code) { joins(:markers).where(markers: { city_code: code }).distinct }

  # Postgres-specific for Case-Insensitive partial matching
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }
end
