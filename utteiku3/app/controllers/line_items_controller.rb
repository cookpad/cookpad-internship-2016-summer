class LineItemsController < ApplicationController
  def create
    order = current_cart_order
    line_item = order.line_items.create!(params.require(:line_item).permit(:item_id, :quantity))

    redirect_to order
  end

  private

  def current_cart_order
    if session[:current_order_id]
      Order.where(status: :cart).find(session[:current_order_id])
    else
      Order.create!.tap do |order|
        session[:current_order_id] = order.id
      end
    end
  end
end

