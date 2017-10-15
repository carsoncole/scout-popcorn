class RemoveColumnNoteFromTakeOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :take_orders, :note, :string
    remove_column :take_orders, :square_reciept_url, :string
  end
end
