class Unit < ApplicationRecord
  has_many :scouts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :ledgers, through: :accounts

  accepts_nested_attributes_for :scouts

  scope :active, -> { joins(:events).where("events.is_active = ?", true) }

  validates :name, presence: true, uniqueness: true
  validates :treasurer_email, format: /@/, unless: Proc.new {|u| u.treasurer_email.blank? }
  validates :treasurer_first_name, presence: true, unless: Proc.new {|u| u.treasurer_email.blank? }

  def treasurer?
    true unless treasurer_email.blank? || treasurer_first_name.blank?
  end

  def treasurer_name
    (treasurer_first_name || '') + ' ' + (treasurer_last_name || '')
  end

  def admin
    scouts.where(is_unit_admin: true)
  end

end