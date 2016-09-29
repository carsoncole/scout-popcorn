class AddEnvelopeIdToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :envelope_id, :integer
  end
end
