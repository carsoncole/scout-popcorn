class AddIsPrizesEnabledToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :is_prizes_enabled, :boolean, default: true
  end
end
