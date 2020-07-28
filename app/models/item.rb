class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.order_by_pop
    Item.joins(:item_orders).select('SUM(item_orders.quantity) AS sum_quantity, items.name').group('items.id').order('SUM(item_orders.quantity) desc').limit(5)
  end

  def self.order_by_least_pop
    Item.joins(:item_orders).select('SUM(item_orders.quantity) AS sum_quantity, items.name').group('items.id').order('SUM(item_orders.quantity)').limit(5)
  end

  def deactivate
    self.update(active?: false)
  end
end
