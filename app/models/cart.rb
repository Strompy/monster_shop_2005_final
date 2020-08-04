class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def cart_quantity(item)
    @contents[item.id.to_s]
  end

  def best_discount(item)
    item.merchant.discounts.where(quantity: cart_quantity(item))
                            .order(percent: :desc).limit(1)
  end

  def gets_discount?(item)
    best_discount(item).count == 1
  end

  def discount_price(item)
    discount = best_discount(item)[0]
    item.price * (1 - (discount.percent  / 100))
  end

  def subtotal(item)
    item.price * cart_quantity(item)
  end

  def discount_subtotal(item)
    discount = best_discount(item)[0]
    cart_quantity(item) * discount_price(item)
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

end
