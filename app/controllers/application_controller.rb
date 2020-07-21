class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def user
    unless session[:user_id].nil?
      @user = User.find(session[:user_id])
    end
  end
end
