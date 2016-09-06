json.extract! @order, :id, :ordered_at, :total, :status, :created_at, :updated_at
json.url order_url(@order)

json.line_items(@order.line_items) do |line_item|
  json.extract! line_item, :quantity, :subtotal
  json.item do
    json.extract! line_item.item, :id, :name, :price
    json.url      item_url(line_item.item)
  end
end

