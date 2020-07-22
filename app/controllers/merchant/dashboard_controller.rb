class Merchant::DashboardController < ApplicationController
  before_action :require_merchant
  def index
  end

  private
  def require_merchant
    if user.nil? || !user.merchant?
      render file: "/public/404"
    end
  end
end
