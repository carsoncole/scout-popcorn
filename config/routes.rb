Rails.application.routes.draw do
  
  patch "envelopes/assign" => "envelopes#assign", as: 'assign_to_envelope'
  post "envelopes/:id/close" => "envelopes#close", as: 'close_envelope'
  post "envelopes/:id/open" => "envelopes#open", as: 'open_envelope'
  put "envelopes/:envelope_id/remove-take-order/:id" => "envelopes#remove_take_order", as: 'envelope_remove_take_order'
  resources :envelopes
  get "ledgers/statements" => "ledgers#statement", as: 'statement'
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
  resources :direct_sales
  resources :online_sales
  resources :take_orders do
    resources :take_order_line_items
  end
  resources :scout_site_sales
  get "stocks/ledger" => "stocks#ledger", as: 'stocks_ledger'
  get "stocks/stock-movement" => "stocks#stock_movement", as: 'stock_movement'
  resources :stocks
  resources :events do
    resources :scout_site_sales
  end
  get "prizes/cart" => "prizes#cart", as: 'prize_cart'
  post "prizes/selection/:id" => "prizes#selection", as: 'prize_selection'
  post "prizes/removal/:id" => "prizes#removal", as: 'prize_removal'
  resources :prizes
  resources :products
  resources :home, only: :index
  resources :top_sellers, only: :index
  resources :purchase_orders, :take_order_purchase_orders
  resources :summary_orders
end