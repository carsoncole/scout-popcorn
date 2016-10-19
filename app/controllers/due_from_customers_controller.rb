class DueFromCustomersController < ApplicationController
  def index
    @due_from_customers = Ledger.joins(:account).where("accounts.event_id = ?", @active_event.id).where("accounts.name = 'Money due from Customer'")
  end
end
