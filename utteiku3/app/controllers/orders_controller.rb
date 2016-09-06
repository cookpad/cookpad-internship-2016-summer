class OrdersController < ApplicationController
  before_action :api_access_only, only: :create

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.transaction { Order.bulk_checkout!(Time.now, bulk_line_item_params) }

    render action: :show, status: 201, location: order_url(@order)
  end

  def update
    @order = Order.find(params[:id])
    if params.dig(:order, :status) == 'checked_out'
      @order.checkout!(Time.now)
      session.delete(:current_order_id)

      redirect_to @order
    else
      head(:bad_request)
    end
  end

  private

  def api_access_only
    head(:not_found) unless valid_api_request?
  end

  def bulk_line_item_params
    params.require(:line_items).map {|li| li.permit(:item_id, :quantity) }
  end
end
