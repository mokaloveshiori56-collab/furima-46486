class PurchaseAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number, :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/ }
    validates :prefecture_id, numericality: { other_than: 1 }
    validates :city
    validates :street_address
    validates :phone_number, format: { with: /\A[0-9]{10,11}\z/ }
    validates :token
  end

  def save
    ActiveRecord::Base.transaction do
      purchase_record = PurchaseRecord.create!(user_id: user_id, item_id: item_id)
      Address.create!(
        prefecture_id: prefecture_id,
        postal_code: postal_code,
        city: city,
        street_address: street_address,
        building_name: building_name,
        phone_number: phone_number,
        purchase_record_id: purchase_record.id
      )
    end
  end
end
