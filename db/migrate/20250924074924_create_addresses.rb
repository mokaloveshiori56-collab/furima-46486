class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :postal_code
      t.integer :prefecture_id
      t.string :city
      t.string :street_address
      t.string :building_name
      t.string :phone_number
      t.references :purchase_record, null: false, foreign_key: true

      t.timestamps
    end
  end
end
