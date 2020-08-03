class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = user.merchant
    # @discounts = @merchant.discounts
  end

  def new
    @user_input ||= Hash.new("")
  end

  def create
    merchant = user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      flash[:success] = "Discount Successfully Created"
      redirect_to "/merchant/discounts"
    else
      @user_input = discount_params
      flash[:error] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.permit(:percent, :quantity)
  end
end
