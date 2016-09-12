class ScoutSiteSale < ApplicationRecord
  belongs_to :scout
  belongs_to :site_sale

  validates :scout, uniqueness: { scope: :site_sale }

  def self.total_event_hours_worked(event)
    where(event_id: event.id).sum(:hours_worked)
  end

end
