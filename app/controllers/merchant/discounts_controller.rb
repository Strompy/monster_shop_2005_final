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

  def edit
    @discount = Discount.find(params[:id])
    @user_input = {percent: @discount[:percent], quantity: @discount[:quantity]}
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      flash[:success] = "Discount Successfully Updated"
      redirect_to merchant_discounts_path
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      @user_input = discount_params
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    flash[:success] = "Discount successfully canceled"
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.permit(:percent, :quantity)
  end
end
