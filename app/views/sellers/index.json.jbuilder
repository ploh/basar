json.array!(@sellers) do |seller|
  json.extract! seller, :name, :number, :initials, :rate
  json.url seller_url(seller, format: :json)
end
