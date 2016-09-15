json.extract! ledger, :id, :account_id, :description, :amount, :date, :created_at, :updated_at
json.url ledger_url(ledger, format: :json)