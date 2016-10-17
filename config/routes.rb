Rails.application.routes.draw do
  
  get 'take_orders_order/index'

  resources :prize_carts

  post 'order-prizes' => 'scout_prize_cart#order-prizes', as: 'order_prizes'
  post "approve-prize-cart/:id" => "prize_carts#approve", as: 'approve_prize_cart'
  post "unapprove-prize-cart/:id" => "prize_carts#unapprove", as: 'unapprove_prize_cart'
  patch "envelopes/assign" => "envelopes#assign", as: 'assign_to_envelope'
  post "envelopes/:id/close" => "envelopes#close", as: 'close_envelope'
  post "envelopes/:id/open" => "envelopes#open", as: 'open_envelope'
  put "envelopes/:envelope_id/remove-take-order/:id" => "envelopes#remove_take_order", as: 'envelope_remove_take_order'
  resources :envelopes do
    resources :take_orders
  end
  get "ledgers/statements/balance-sheet" => "ledgers#balance_sheet", as: 'balance_sheet'
   get "ledgers/final-unit-settlement-form" => "ledgers#final_unit_settlement_form", as: 'final_unit_settlement_form'
  get "ledgers/statements/income-statement" => "ledgers#income_statement", as: 'income_statement'
  resources :ledgers
  get 'bank-deposit' => "ledgers#bank_deposit", as: 'bank_deposit'
  resources :accounts
  resources :payment_methods
  get 'help/index'

  root "home#index"
  devise_for :scouts, :controllers => { registrations: 'registrations' }
  resources :units
  resources :scouts do
    get 'update-password' => 'scouts#update_password', as: 'update_password'
  end
  resources :site_sales do
    get "tracking_sheet" => "site_sales#tracking_sheet", as: 'tracking_sheet'
    resources :site_sale_payment_methods
    resources :site_sale_line_items
    resources :scout_site_sales
  end
  resources :online_sales

  # get "take-orders/pick-sheet" => 'take_orders#pick_sheet' as: :print_take_order_pick_sheet
  resources :take_orders do
    resources :take_order_line_items
  end
  resources :scout_site_sales
  get "stocks/ledger" => "stocks#ledger", as: 'stocks_ledger'
  get "stocks/inventory-returns" => "stocks#inventory_returns", as: 'inventory_returns'
  get "stocks/stock-movement" => "stocks#stock_movement", as: 'stock_movement'
  resources :stocks
  resources :events do
    resources :scout_site_sales
  end
  post "prize-cart/selection/:id" => "prize_carts#selection", as: 'prize_selection'
  post "prize-cart/removal/:id" => "prize_carts#removal", as: 'prize_removal'
  resources :prizes
  resources :products
  resources :home, only: :index
  resources :top_sellers, only: :index
  resources :purchase_orders, :take_order_purchase_orders
  resources :summary_orders
end