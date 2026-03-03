class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.string :image_url
      t.string :user_name
      t.string :user_pic
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
