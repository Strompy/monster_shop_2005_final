class Merchant::DashboardController < Merchant::BaseController

  def index
    binding.pry
    @merchant = user
  end
end
