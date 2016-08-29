class SummaryOrdersController < ApplicationController

  def index
    @products = Product.all
  end
end