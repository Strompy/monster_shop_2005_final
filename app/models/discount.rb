class Discount < ApplicationRecord
  validates_presence_of :percent
  validates_presence_of :quantity
  belongs_to :merchant

  # def display_percentage
  #   number_to_percentage(percent)
  # end
end
