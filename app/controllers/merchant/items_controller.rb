class Merchant::ItemsController < Merchant::BaseController

  def index
    @items = user.merchant.items
  end

  def destroy
    item = Item.find(params[:item_id])
    item.deactivate
    redirect_to "/merchant/items"
    flash[:success] = "Item is no longer for sale"
  end
end
