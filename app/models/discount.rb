class Discount < ApplicationRecord
  validates_presence_of :percent
  validates_presence_of :quantity
  validates_numericality_of :percent, greater_than: 0, less_than_or_equal_to: 100
  validates_numericality_of :quantity, greater_than: 0

  belongs_to :merchant
end
