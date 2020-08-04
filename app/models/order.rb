class Order < ApplicationRecord
  after_initialize :default_status

  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(pending packaged fulfilled shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  # def create_item_orders(cart)
  #   cart.items.each do |item,quantity|
  #     order.item_orders.create({
  #       item: item,
  #       quantity: quantity,
  #       price: item.price
  #       })
  #   end
  # end

  def cancel_item_orders
    item_orders.each do |item_order|
      item_order.status = 2
      item_order.save
    end
  end

  def merchant_item_orders(merchant_id)
    item_orders.where(item_merchant_id: merchant_id)
  end

  private

  def default_status
    self.status = 0 if status.nil?
  end
end
