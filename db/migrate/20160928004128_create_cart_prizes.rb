class CreateCartPrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_prizes do |t|
      t.integer :prize_cart_id
      t.integer :prize_id
      t.integer :prize_amount
      t.integer :quantity, default: 0, null: false
      
      t.timestamps
    end
  end
end
