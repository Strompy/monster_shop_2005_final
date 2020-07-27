class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    merchant.update(status: 1)
    flash[:success] = "Merchant has been disabled"
    redirect_to "/admin/merchants"
  end
end
