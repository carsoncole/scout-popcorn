class AddProductPickedUpAtToEnvelopes < ActiveRecord::Migration[5.0]
  def change
    add_column :envelopes, :product_picked_up_at, :datetime
  end
end
