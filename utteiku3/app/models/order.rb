class Order < ApplicationRecord
  has_many :line_items
  enum status: {
    cart:        0,
    checked_out: 1,
  }

  class << self
    def bulk_checkout!(at, line_items)
      order = create!
      line_items.each { |line_item| order.line_items.create!(line_item) }

      order.tap {|o| o.checkout!(at) }
    end
  end

  def checkout!(at)
    update!(status: :checked_out, ordered_at: at)
  end

  def total
    line_items.sum(&:subtotal)
  end

end
