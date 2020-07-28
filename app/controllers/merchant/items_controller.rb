class Merchant::ItemsController < Merchant::BaseController

  def index
    @items = user.merchant.items
  end
end
