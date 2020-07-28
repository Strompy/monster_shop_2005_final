class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = user
  end
end
