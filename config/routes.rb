Rails.application.routes.draw do
  get 'help/index'

  root "home#index"
  devise_for :scouts, :controllers => { registrations: 'registrations' }
  resources :units
  resources :scouts
  resources :site_sales do
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
  resources :stocks
  resources :events do
    resources :scout_site_sales
  end
  resources :prizes
  resources :products
  resources :home, only: :index
  resources :top_sellers, only: :index
  resources :purchase_orders, :take_order_purchase_orders
  resources :summary_orders
end