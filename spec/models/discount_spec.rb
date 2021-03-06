require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_numericality_of(:percent).is_greater_than(0).is_less_than_or_equal_to(100) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
  describe "relationships" do
    it {should belong_to :merchant}
  end
  # describe "instance methods" do
  #   @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
  #   discount = @dog_shop.discounts.create(percent: 5, quantity: 4)
  #   discount2 = @dog_shop.discounts.create(percent: 12.5, quantity: 4)
  # end
end
