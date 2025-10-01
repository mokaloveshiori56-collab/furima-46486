class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :purchase_record

  def sold_out?
    purchase_record.present?
  end

  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :category
  belongs_to :item_condition
  belongs_to :shipping_fee_burden
  belongs_to :prefecture
  belongs_to :days_to_ship

  with_options presence: true do
    validates :image
    validates :item_name
    validates :item_description
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999, only_integer: true }
  end

  # ActiveHashのIDに対するバリデーション
  # '---'が選択されたままでは保存できないようにする
  with_options numericality: { other_than: 1, message: "can't be blank" } do
    validates :category_id
    validates :item_condition_id
    validates :shipping_fee_burden_id
    validates :prefecture_id
    validates :days_to_ship_id
  end
end
