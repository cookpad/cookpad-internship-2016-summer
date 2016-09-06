class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    item.price * quantity
  end
end
