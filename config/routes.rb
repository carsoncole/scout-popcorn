Rails.application.routes.draw do
  root "sessions#new"
  get '/home' => 'home#index', as: 'home'

  resources :sessions, :resources, :payment_methods, :online_sales, :prizes, :products, :scout_site_sales

  get 'signup', to: 'scouts#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'forgot_password', to: 'scouts#forgot_password', as: 'forgot_password'
  post 'reset_password', to: 'scouts#forget_password_send', as: 'reset_password'

  get 'take-orders-order' => 'take_orders_order#index', as: 'take_orders_order'

  get 'ledgers/transactions' => 'ledgers#transactions', as: :ledger_transactions
  get 'ledgers/fund-site-sales' => 'ledgers#fund_site_sales', as: :fund_site_sales
  post 'ledgers/fund-site-sales' => 'ledgers#fund_site_sales'
  get 'ledgers/bank-deposit' => "ledgers#new_bank_deposit", as: 'new_bank_deposit'
  post 'ledgers/bank-deposit' => 'ledgers#create_bank_deposit'
  get 'ledgers/expense-reimbursement-1' => "ledgers#expense_reimbursement_1", as: 'expense_reimbursement_1'
  post 'ledgers/expense-reimbursement-1' => 'ledgers#expense_reimbursement_1'
  get 'ledgers/expense-reimbursement-2' => "ledgers#expense_reimbursement_2", as: 'expense_reimbursement_2'
  post 'ledgers/expense-reimbursement-2' => 'ledgers#expense_reimbursement_2'
  get 'ledgers/collect-from-customer' => "ledgers#collect_from_customer", as: 'collect_from_customer'
  post 'ledgers/collect-from-customer' => 'ledgers#collect_from_customer'

  resources :ledgers

  resources :due_from_customers, only: :index

  get 'events/:id/commissions' => 'events#edit_commission_percentage', as: 'edit_commission_percentage'

  get "product-preset-collections" => 'products#preset_collections', as: 'preset_product_collections'
  post "product-preset-collections" => 'products#add_preset_collection', as: 'add_presets'

  get "reports/summary" => 'reports#summary', as: 'summary_report'

  resources :prize_carts, only: [:index, :show], path: 'prize-carts'
  post 'prize-cart/order' => 'prize_carts#order', as: 'prize_cart_order'
  post 'prize-carts/:id' => 'prize_carts#order_prizes', as: 'order_prizes'
  get 'approved-prizes' => 'prize_carts#approved_prizes', as: 'approved_prizes'
  post "approve-prize-cart/:id" => "prize_carts#approve", as: 'approve_prize_cart'
  post "unapprove-prize-cart/:id" => "prize_carts#unapprove", as: 'unapprove_prize_cart'
    post "prize-cart/removal/:id" => "prize_carts#removal", as: 'prize_removal'
  post "unorder-prize-cart/:id" => "prize_carts#unorder", as: 'unorder_prize_cart'
  patch "envelopes/assign" => "envelopes#assign", as: 'assign_to_envelope'
  post "envelopes/:id/close" => "envelopes#close", as: 'close_envelope'
  post "envelopes/:id/open" => "envelopes#open", as: 'open_envelope'
  post "envelopes/:id/picked-up" => "envelopes#picked_up", as: 'picked_up_envelope'
  put "envelopes/:envelope_id/remove-take-order/:id" => "envelopes#remove_take_order", as: 'envelope_remove_take_order'
  resources :envelopes do
    resources :take_orders
  end
  get "ledgers/statements/balance-sheet" => "ledgers#balance_sheet", as: 'balance_sheet'
   get "ledgers/final-unit-settlement-form" => "ledgers#final_unit_settlement_form", as: 'final_unit_settlement_form'
  get "ledgers/statements/income-statement" => "ledgers#income_statement", as: 'income_statement'

  get 'home/invite_scouts' => 'home#invite_scouts', as: 'invite_scouts'

  resources :units, except: :index
  resources :scouts do
    get 'update-password' => 'scouts#update_password', as: 'update_password'
  end
  resources :site_sales, path: 'site-sales' do
    get "tracking_sheet" => "site_sales#tracking_sheet", as: 'tracking_sheet'
    resources :site_sale_payment_methods, except: :index
    resources :site_sale_line_items
    resources :scout_site_sales
  end

  # get "take-orders/pick-sheet" => 'take_orders#pick_sheet' as: :print_take_order_pick_sheet
  resources :take_orders, path: 'take-orders' do
    resources :take_order_line_items
  end
  get "stocks/ledger" => "stocks#ledger", as: 'stocks_ledger'
  get "stocks/inventory-returns" => "stocks#inventory_returns", as: 'inventory_returns'
  get "stocks/stock-transfer-form" => "stocks#stock_transfer_form", as: 'stock_transfer_form'
  get "stocks/stock-transfers-report" => "stocks#stock_transfers_report", as: 'stock_transfers_report'
  post "stocks/stock-transfers-report" => "stocks#stock_transfers_report", as: 'stock_transfers_report_date'

  resources :stocks
  resources :events do
    get 'activate' => 'events#activate', as: 'activate'
    resources :scout_site_sales
    resources :resources
  end

  resources :top_sellers, only: :index
  resources :purchase_orders, :take_order_purchase_orders
  resources :summary_orders
end