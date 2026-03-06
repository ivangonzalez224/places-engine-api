class Place < ApplicationRecord
  has_many :markers, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  #  0 to 'resto' and 1 to 'tienda'
  enum place_type: { resto: 0, tienda: 1 }

  # Validations
  validates :name, :place_type, presence: true

  # Scopes for clean API queries
  scope :vegan, -> { where(is_vegan: true) }
  scope :by_city, ->(code) { joins(:markers).where(markers: { city_code: code }).distinct }

  # Postgres-specific for Case-Insensitive partial matching
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }

  def add_rating(new_score)
    ActiveRecord::Base.transaction do
      new_count = self.ratings_count + 1
      
      # handle decimal math correctly
      new_average = ((self.average_rating * self.ratings_count) + new_score.to_f) / new_count

      update!(
        average_rating: new_average.round(2),
        ratings_count: new_count
      )
    end
  end
end
