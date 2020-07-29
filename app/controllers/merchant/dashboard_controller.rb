class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = user.merchant
    # require "pry"; binding.pry
  end
end
