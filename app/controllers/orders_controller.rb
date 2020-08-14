class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = user.orders.create(order_params)
    if order.save
      price_selector(order)
      session.delete(:cart)
      flash[:success] = "Order successfully placed"
      redirect_by_role(order)
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    if order.item_orders.all? {|i_o| i_o. status == 'fulfilled'}
      order.update(status: 1)
    end
    redirect_to "/profile/orders/#{order.id}"
  end

  def destroy
    order = Order.find(params[:id])
    # return any fulfilled items to merchants
    order.status = 4
    order.cancel_item_orders
    order.save
    flash[:success] = "Your order is cancelled"
    redirect_by_role(order)
  end

  private

  def redirect_by_role(order)
    if user.default?
      redirect_to '/profile/orders'
    else
      redirect_to "/orders/#{order.id}"
    end
  end

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def price_selector(order)
    cart.items.each do |item,quantity|
      if cart.gets_discount?(item)
        create_discount_item_order(order, item, quantity)
      else
        create_item_order(order, item, quantity)
      end
    end
  end

  def create_discount_item_order(order, item, quantity)
    order.item_orders.create({
      item: item,
      quantity: quantity,
      price: cart.discount_price(item)
      })
  end

  def create_item_order(order, item, quantity)
    order.item_orders.create({
      item: item,
      quantity: quantity,
      price: item.price
      })
  end
end
