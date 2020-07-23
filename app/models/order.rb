class Order < ApplicationRecord
  after_initialize :default_status

  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(pending packaged fulfilled shipped)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  private

  def default_status
    self.status = 0 if status.nil?
  end
end
