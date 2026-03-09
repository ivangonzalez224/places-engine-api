class Comment < ApplicationRecord
  belongs_to :place

  has_many_attached :photos

  # Controla el límite de fotos y el tipo de archivo
  validate :validate_photos_limit
  validate :validate_photos_type

  private

  def validate_photos_limit
    if photos.attached? && photos.count > 5
      errors.add(:photos, "no pueden ser más de 5 por comentario")
    end
  end

  def validate_photos_type
    return unless photos.attached?
    
    photos.each do |photo|
      unless photo.content_type.in?(%w[image/jpeg image/png image/jpg image/webp])
        errors.add(:photos, "deben ser imágenes (JPEG, PNG o WEBP)")
      end
    end
  end
end
