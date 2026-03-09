class CommentBlueprint < Blueprinter::Base
  identifier :id
  fields :content, :user_name, :user_pic, :created_at

  # Campo para las imágenes
  field :images do |comment, _options|
    image_list = []
    
    # Agrega URL de img si existe
    image_list << comment.image_url if comment.image_url.present?
    
    # Agrega URLs de las fotos nuevas de Active Storage
    if comment.photos.attached?
      comment.photos.each do |photo|
        # genera una URL válida
        image_list << Rails.application.routes.url_helpers.url_for(photo)
      end
    end
    
    image_list
  end
end