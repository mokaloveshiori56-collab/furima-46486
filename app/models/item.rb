class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :category
  belongs_to :item_condition
  belongs_to :shipping_fee_burden
  belongs_to :prefecture
  belongs_to :days_to_ship

end
