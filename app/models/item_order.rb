class ItemOrder <ApplicationRecord
  after_initialize :default_status

  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  enum status: %w(pending packaged unfulfilled fulfilled shipped cancelled)

  def subtotal
    price * quantity
  end

  private

  def default_status
    self.status = 0 if status.nil?
  end

end
