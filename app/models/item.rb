class Item < ApplicationRecord
  has_one_attached :image

  has_many :order_details, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  belongs_to :genre
  has_many :orders, through: :order_details

  validates :name, presence: true
  validates :image, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :genre_id, presence: true

  def self.search_for(content,method)
    return none if content.blank?
     if method == 'perfect'
       Item.where(name: content)
     elsif method == 'forward'
       Item.where('name LIKE ?', content + '%')
     elsif method == 'backword'
       Item.where('name LIKE ?', '%' + content)
     else
       Item.where('name LIKE ?', '%' + content + '%')
     end
  end

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def with_tax_price
    (price * 1.1).floor
  end
end
