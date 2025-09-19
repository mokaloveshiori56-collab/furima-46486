class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :item_name
      t.text :item_description
      t.integer :category_id
      t.integer :item_condition_id
      t.integer :shipping_fee_burden_id
      t.integer :prefecture_id
      t.integer :days_to_ship_id
      t.integer :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
