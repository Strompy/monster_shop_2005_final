class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @orders = Order.all
  end

  private
  def require_admin
    if user.nil? || !user.admin?
      render file: "/public/404"
    end
  end
end
