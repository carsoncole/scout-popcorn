class AddNoteToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :note, :string
  end
end