class Scout < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :unit
  has_many :take_orders
  has_many :events, through: :unit
  has_many :site_sales, through: :scout_site_sales
  has_many :scout_site_sales
  has_many :direct_sales
  has_many :online_sales

  validates :first_name, :last_name, :email, presence: true
  before_save :fix_name!
  after_create :set_unit!
  after_create :set_default_event!
  after_create :set_if_admin!
  after_create :send_registration_email!
  after_create :send_you_are_registered_email!, unless: Proc.new {|s| s.is_admin?}

  ADMINS = [['nathan','oestreich'], ['nicole', 'bavo'], ['carson', 'cole'],['candace', 'luckman'], ['charlotte', 'boulind-yeung'], ['kevin', 'daniels'],['lisa', 'cass'], ['keri', 'pinzon']]

  def name
    first_name + ' ' + last_name
  end

  def self.not_admin
    where(is_admin: nil)
  end

  def parent_name
    (parent_first_name||'') + ' ' + (parent_last_name||'')
  end

  def total_sales(event)
    total = 0
    take_orders.where(event_id: event).each do |to|
      total += to.value
    end
    total
  end

  def default_event
    Event.find(default_event_id) rescue nil
  end

  def set_default_event!
    update(default_event_id: unit.events.active.last.id) if unit.events
  end

  def event_site_sale_hours_worked(event)
    scout_site_sales.joins(:site_sale).where("site_sales.event_id = ?",event.id).sum(:hours_worked)
  end

  private

  def set_unit!
    self.update(unit_id: 1)
  end

  def fix_name!
    self.first_name = first_name.capitalize if first_name
    self.last_name = last_name.capitalize if last_name
  end

  def set_if_admin!
    if ADMINS.include? [first_name.downcase, last_name.downcase] 
      update(is_admin: true) 
    end
  end

  def send_registration_email!
    ScoutMailer.registration(self).deliver_later
  end

  def send_you_are_registered_email!
    ScoutMailer.you_are_registered(self).deliver_later
  end

end
