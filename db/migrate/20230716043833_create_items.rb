class CreateItems < ActiveRecord::Migration[6.1]
  belongs_to :genre, optional: true
  has_one_attached :image

  def change
    create_table :items do |t|

      t.string :name,       null: false
      t.text :introduction, null: false
      t.integer :price,     null: false
      t.integer :genre_id,  null: false
      t.boolean :is_sold,   default: true, null: false
      t.string :image_id
      t.timestamps
    end
  end
end
