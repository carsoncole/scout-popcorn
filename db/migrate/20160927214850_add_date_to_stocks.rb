class AddDateToStocks < ActiveRecord::Migration[5.0]

  def up
    add_column :stocks, :date, :date
    Stock.all.each do |s|
      s.update(date: s.created_at)
    end
  end

  def down
    remove_column :stocks, :date
  end
end
