class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = user.merchant
    # @discounts = @merchant.discounts
  end
end
