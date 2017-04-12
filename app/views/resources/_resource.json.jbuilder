json.extract! resource, :id, :event_id, :name, :url, :created_at, :updated_at
json.url resource_url(resource, format: :json)