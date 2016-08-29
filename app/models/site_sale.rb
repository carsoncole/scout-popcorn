class SiteSale < ApplicationRecord
  has_many :scout_site_sales
  belongs_to :event

  def credited_sales(scout)
    if scout_site_sales.where(scout_id: scout.id).first
      hours_worked(scout) * sales_per_hour_worked
    end
  end

  def hours_worked(scout)
    if scout_site_sales.where(scout_id: scout.id).first
      scout_site_sales.where(scout_id: scout.id).first.hours_worked
    end
  end

  def sales_per_hour_worked
    total_sales / total_hours_worked
  end

  def total_hours_worked
    scout_site_sales.sum(:hours_worked)
  end
end
