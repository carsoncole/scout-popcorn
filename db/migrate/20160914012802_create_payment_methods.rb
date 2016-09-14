class CreatePaymentMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.string :unit_id
      t.boolean :is_active, default: true
      t.boolean :is_cash

      t.timestamps
    end
  end
end
