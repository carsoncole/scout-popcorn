class AddResetTokenToScouts < ActiveRecord::Migration[5.1]
  def change
    add_column :scouts, :password_reset_token, :string
  end
end
