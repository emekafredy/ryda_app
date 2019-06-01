json.extract! request, :id, :origin, :destination, :take_off, :user_id, :status, :offer_id, :created_at, :updated_at
json.url request_url(request, format: :json)
