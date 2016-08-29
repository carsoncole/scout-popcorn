Rails.application.routes.draw do
  root "home#index"
  devise_for :scouts, :controllers => { registrations: 'registrations' } do
    get '/scouts/sign_out' => 'devise/sessions#destroy'
  end
  resources :units
  resources :scouts
  resources :site_sales
  resources :direct_sales
  resources :take_orders do
    resources :line_items
  end
  resources :scout_site_sales
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