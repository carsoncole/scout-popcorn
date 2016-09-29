json.extract! envelope, :id, :scout_id, :event_id, :status, :created_at, :updated_at
json.url envelope_url(envelope, format: :json)