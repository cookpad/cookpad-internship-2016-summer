class PortalController < ApplicationController
  def show
    @categories = Category.all
  end
end
