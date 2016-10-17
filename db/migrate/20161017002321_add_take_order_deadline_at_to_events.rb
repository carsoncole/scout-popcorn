class AddTakeOrderDeadlineAtToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :take_orders_deadline_at, :datetime
  end
end
