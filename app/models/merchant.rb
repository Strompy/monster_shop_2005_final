class Merchant <ApplicationRecord
  after_initialize :set_status
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  enum status: %w(Enabled Disabled)

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def deactivate_all_items
    items.each do |item|
      item.update(active?: false)
    end
  end

  def activate_all_items
    items.each do |item|
      item.update(active?: true)
    end
  end

  private

  def set_status
    self.status = 0 if status.nil?
  end
end
