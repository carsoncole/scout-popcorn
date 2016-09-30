class AddIsPackDonationToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :is_pack_donation, :boolean
  end
end
