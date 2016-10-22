class DueFromCustomersController < ApplicationController
  def index
    @due_from_customers = Ledger.joins(:account).where("accounts.event_id = ?", @active_event.id).where("accounts.id = ?", Account.money_due_from_customer(@active_event))
  end
end
