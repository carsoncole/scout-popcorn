json.extract! payment_method, :id, :name, :unit_id, :is_active, :created_at, :updated_at
json.url payment_method_url(payment_method, format: :json)