class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.integer :book_id
      t.integer :shopper_id
      t.boolean :return?, default: false
    end
  end
end
