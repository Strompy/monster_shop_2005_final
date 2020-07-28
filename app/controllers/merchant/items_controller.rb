class Merchant::ItemsController < Merchant::BaseController

  def index
    @items = user.merchant.items
  end

  def destroy
    item = Item.find(params[:item_id])
    if item.no_orders?
      item.delete
      flash[:success] = "Item has been deleted"
    else
      flash[:error] = "Item has been ordered before and cannot be deleted"
    end
    redirect_to "/merchant/items"
  end

  def update
    item = Item.find(params[:item_id])
    if item.active?
      item.deactivate
      flash[:success] = "Item is no longer for sale"
    else
      item.activate
      flash[:success] = "Item is now available for sale"
    end
    redirect_to "/merchant/items"
  end
end
