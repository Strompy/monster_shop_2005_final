class Merchant::ItemsController < ApplicationController

  def index
    @items = user.merchant.items
  end
end
