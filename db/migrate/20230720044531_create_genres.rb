class CreateGenres < ActiveRecord::Migration[6.1]
  has_many :items
  validates :name, presence:true

  def change
    create_table :genres do |t|

      t.string :name

      t.timestamps
    end
  end
end
