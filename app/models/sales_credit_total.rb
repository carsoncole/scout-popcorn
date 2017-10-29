class SalesCreditTotal < ApplicationRecord
  belongs_to :scout
  belongs_to :event

  after_create :add_to_balance!

  validates :event_id, uniqueness: { scope: :scout_id }

  private

  def add_to_balance!
    SalesCredit.create(scout_id: self.scout_id, amount: self.amount, event_id: self.event_id)
  end
end