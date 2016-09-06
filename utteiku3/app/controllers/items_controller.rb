class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = collection_root
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  def recommended
    @items = Item.where(recommended: true).all
    render action: :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def collection_root
      if params[:category_id]
        Category.find(params[:category_id]).items
      else
        Item.all
      end
    end

end
