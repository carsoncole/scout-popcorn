class ScoutSiteSale < ApplicationRecord
  belongs_to :scout
  belongs_to :site_sale

  validates :scout, uniqueness: { scope: :site_sale }
end
