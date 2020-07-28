class Merchant::ItemsController < Merchant::BaseController

  def index
    @items = user.merchant.items
  end

  def new
    @user_input ||= Hash.new("")
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

  def create
    item = user.merchant.items.create(item_params)
    if item.save
      flash[:success] = "Item has been saved"
      redirect_to "/merchant/items"
    else
      @user_input = item_params
      flash[:errors] = item.errors.full_messages
      render :new
    end
  end

  private
  def item_params
    if params[:image].empty?
      params[:image] = "https://cateringbywestwood.com/wp-content/uploads/2015/11/dog-placeholder.jpg"
    end
    params.permit(:name, :description, :price, :image, :inventory)
  end
end
