json.array!(@categories) do |category|
  json.extract! category, :id, :name
  json.image_url  image_url(category.image_url)
  json.category_items_url category_items_url(category, format: :json)
end
