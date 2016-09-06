json.extract! item, :id, :name, :description, :price, :created_at, :updated_at
json.image_url  image_url(item.image_url)
json.url item_url(item, format: :json)
