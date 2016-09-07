class PurchaseOrder < ApplicationRecord
  belongs_to :event
  has_many :take_orders

  validates :event_id, :type, presence: true

  before_save :update_ordered_at!, if: Proc.new {|po| po.status_changed? && po.status == 'ordered'}
  after_save :update_status_on_take_orders!, if: Proc.new {|po| po.status_changed? && po.status == 'ordered' }

  TYPES = [
    { type: :take_order, name: 'Take Order' },
    { type: :site_sale, name: 'Site Sale'}
  ]

  STATUSES = [
      { status: :open, name: 'Open' },
      { status: :ordered, name: 'Ordered' }
    ]

  private

  def update_status_on_take_orders!
    take_orders.update_all(status: :ordered)
  end

  def update_ordered_at!
    self.ordered_at = Time.current
  end
end
