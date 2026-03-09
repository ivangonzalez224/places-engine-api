class CommentBlueprint < Blueprinter::Base
  identifier :id
  fields :content, :user_name, :user_pic, :created_at
end