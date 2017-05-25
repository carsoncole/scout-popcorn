class SiteSalePaymentMethod < ApplicationRecord
  belongs_to :site_sale
  belongs_to :account

  validates :account_id, :amount, presence: true
  validates :amount, numericality: true
end