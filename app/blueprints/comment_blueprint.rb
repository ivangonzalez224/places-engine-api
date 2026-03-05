class CommentBlueprint < Blueprinter::Base
  identifier :id
  fields :content, :user_name, :image_url, :user_pic
end